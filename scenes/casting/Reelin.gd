extends Spatial

var castResource : CastResource

export var catchRange = 2.0
export var lineDamage = 0.5 #damage to line per tick of going over the target speed
export var timeToCatch = 42 #time the player gets to reel in the fish
export var lineHealth = 52 #the health of the line, declines when the player reels in too fast
export var lineBuffer = 18
export var catchRate = 36 #the "health" of the fish, declines most when player is closest to targetTime
export var catchHikeLength = 6
export var catchHikeIndex = 0
export var yankLineHealthDamage = 8
export var yankAmount = .2
export var currentYank = 0.0
export var yankDecay = .05
export var targetTime = 0.5 #the target amount of seconds between "tick" or checkpoints in rotating your joystick
export var eyesOnTime = 24 #amount of time the fish is allowed to be out of screen
export var lineInterpolateFrames = 12 #amount of frames to interpolate between castline and straight line to fish until setting it to a line of 2 points
export(PackedScene) var uiScene
onready var line = $LineRenderer
onready var rotator = $Rotation
onready var obs = $Observer

var reeledIn = false
var uinode = null
var currentLineBuffer = 18
var minFOV = 65
var FOVdif = 70 - minFOV
var initialCatchRate = catchRate
var idealTimeModifier = 1.0
var reelinFish = null
var active = false
var oldArray = []
var targetArray = []
var lineArray = []
var inSight = true #bool to keep track if the fish is in los, if not it wont handle ticks and wont reel in more
var reelinSpeed = 0 #var that is subtracted from catchrate every frame, making it more smoothly than stepwise, this var is updated every tick though
var targetReelinSpeed = 0 #this holds the target speed wher the reelinSpeed itself will lerp towards
var catchSpeed = 0.0

signal reel_succes
signal reel_fail
signal tick

func _ready():
	FOVdif = 70 - minFOV
	rotator.connect("tick", self, "handle_tick")

func _process(delta):
	if active: #if active
		
		targetReelinSpeed = move_toward(targetReelinSpeed, 0.0, delta)
		timeToCatch -= delta #decline the time you have to catch the fish
		if reelinFish: #check to see if you have a fish you're reeling in
			if lineInterpolateFrames > 0: #if still interpolating between castline and straight line to fish
				var tvec = reelinFish.get_node("HeadPoint").global_transform.origin - global_transform.origin #get vec between player and fish
				targetArray = HelperScripts.vec_to_array(tvec, oldArray.size(), global_transform.origin) #get an array of points between player and fish
				HelperScripts.interpolate_arrays(oldArray, targetArray, 10*delta) #interpolate the oldarray that comes from the castarray to the targetarray that is a straight line
				line.points = oldArray #set the drawline points
				lineInterpolateFrames -= 1 #decrease frames
			else: #otherwise
				line.points = [global_transform.origin, reelinFish.get_node("HeadPoint").global_transform.origin] #just draw a line with 2 points
			if inSight:
				reelinSpeed = move_toward(reelinSpeed, targetReelinSpeed, 0.4)
				var fishDot = $FishDotter.get_fish_dot(reelinFish)
				var camDot = $FishDotter.get_cam_dot(reelinFish)
				var dot = fishDot + camDot
				idealTimeModifier = min(1.0, 1.0 - (fishDot * 0.5))
				catchRate -= catchSpeed * (1.0+dot) * delta #subtract actual reelinspeed from catchrate
				var damage = max(0.0 ,(reelinSpeed - 1.0)) * delta * 20.0
				if damage > 0.0:
					if currentLineBuffer > 0:
						currentLineBuffer -= damage
					else:
						lineHealth -= damage
				else:
					currentLineBuffer = move_toward(currentLineBuffer, lineBuffer, delta * 4.0) 
				var lineLength = calculate_line_length()
				print(lineLength)
				reelinFish.hookedAmount = lineLength #supply the fish with a normalized number, being the amount the fish is reeled in, it uses it to find the nearest point on a sphere around the player
				GlobalSingleton.cam.targetFOV = minFOV + FOVdif * catchRate / initialCatchRate 
				emit_signal("tick", {catchRate = catchRate, lineHealth = lineHealth, time = reelinSpeed}) #emit signal mostly to gui, to show off
		decay_yank()
		if Input.is_action_just_pressed("a"):
			yank()
		if catchRate <= 0:
			reeledIn = true 
		if timeToCatch <= 0:
			fish_loose()
			return
		if lineHealth <= 0:
			line_break()
		if reeledIn && (reelinFish.global_transform.origin - global_transform.origin).length() < catchRange:
			fish_caught()
			return

func start(fish, castarray):
	uinode = uiScene.instance()
	uinode.init({catchRate = catchRate, lineHealth = lineHealth, time = timeToCatch})
	add_child(uinode)
	var _ce = connect("tree_exited", uinode, "queue_free")
	var _cee = connect("tick", uinode, "_on_Reelin_tick")
	var _ceee = connect("reel_succes", fish, "reeled_in")
	var _ceeee = connect("reel_fail", fish, "broke_free")
	
	var tvec = fish.get_node("HeadPoint").global_transform.origin - global_transform.origin
	targetArray = HelperScripts.vec_to_array(tvec, castarray.size(), global_transform.origin)
	oldArray = castarray
	active = true
	reelinFish = fish
	reelinFish.hookedAmount = 1 #sets hookedamount to 1, will decrease to 0 as you reel in the fish, making it wander clsoer by to the player
	rotator.start()
	obs.start_observer(fish)

func calculate_line_length():
	return max(0.0,(catchRate / initialCatchRate) - currentYank)

func stop():
	rotator.stop()
	queue_free()

func handle_tick(time):
	if inSight: #if the fish is in sight
		if time > 0:
#			targetReelinSpeed = max(0, (targetTime * idealTimeModifier / time) - .5) 
			reelinSpeed = max(0, ((targetTime * idealTimeModifier) / time)) 
			catchSpeed = 1.0 - time
			print(str(time) + " " + str(targetTime * idealTimeModifier) + " " + str(reelinSpeed) + ', ' + str(idealTimeModifier))
	else:
		print("Fish not in sight!")

func line_break():
	castResource.got_away()
#	GlobalSingleton.glob_unhook(reelinFish)
	emit_signal("reel_fail", reelinFish)
	stop()

func fish_loose():
	castResource.got_away()
#	GlobalSingleton.glob_unhook(reelinFish)
	emit_signal("reel_fail", reelinFish)
	stop()

func fish_caught():
	castResource.reeled_in_fish()
#	GlobalSingleton.glob_catch(reelinFish)
	emit_signal("reel_succes", reelinFish)
	stop()

func yank():
	if currentYank == 0.0:
		currentYank = yankAmount
		lineHealth -= yankLineHealthDamage 

func decay_yank():
	currentYank = move_toward(currentYank, 0.0, yankDecay)

func _on_Observer_isin(_time):
	inSight = true

func _on_Observer_isout(time):
	inSight = false
	eyesOnTime -= time
	if eyesOnTime <= 0:
		fish_loose()
