extends Moved
class_name Fish

const hookedRadius = 20 #the max distance, without offset, the fish swims from the player after it is hooked
const hookedRadiusOffset = 3 #the min distance the fish swims from the player afters its hooked, when its all the way reeled in

export(NodePath) var centerPoint
export(Resource) var initialMoverResource
export(PackedScene) var fishTalkScene = preload("res://scenes/fish/FishTalk.tscn")
export var debug = true
var fishData : FishData setget set_fish_data
var fishSave

var hookedTo = null #this node will be set to the angle the fish is hooked to, by the hooked method
var hookedAmount = 1 #a flaot between 0 and 1 telling the amount the fish is reeled in when it is hooked, this var is manipulated by the reelinnode under angle, THIS IS BAD

var followPoint
var fishTalk #holds refeerence to this fish fishtalk node
var flow #holds reference to this fish' flownfield node
var flock = null #holds reference to this fish' flock node
var flockData 
var baitNode # holds reference to bait fish is baited to  DEPRECATE$D used in bait state, to follow this bait, also used to switch back to default state if the bait is freed from queue
var hook #holds reference to hook fish is hooked to used in hooked state, to know the distance the fish should swim from the player, also used to switch back to default state if the hook is freed from queue

enum fishState{stasis, default, baited, hooked, talking} #states for fish, default is swimming around, baited is swimming towards bait, ignoring other follows, hooked is swimming wildly ignoring other follows
var state = fishState.default

onready var animationPlayer = $AnimationPlayer

signal caught
signal hooked
signal reeledin
signal brokefree
signal start_play
signal released
signal fishready
signal fish_activated
signal fish_deactivated
signal transform_out
signal velocity_out

func _ready():
	flow = FlowField.new()
	var _ce = $WallSense.connect("wall_sensed", self, "evade_wall")
	if fishData == null:
		fishData = FishData.new()
		fishData.generate()
	emit_signal("fishready", self)
	emit_signal("fish_activated")
	if centerPoint:
		centerPoint = get_node(centerPoint)
		var moverInstance = MoverInstance.new()
		moverInstance.initialize_with_resource_and_body(initialMoverResource, centerPoint)
		add_mover(moverInstance)
		

func _process(delta):
	emit_signal('transform_out', global_transform)
	mass = fishData.mass
	if state == fishState.default:
		iterate_movers(delta) #is a mnethod from the Moved class the fish inherits from, loops trhough a dict of movers and moves accordingly to the data they hold
		if flow:
			fish_flow(flow, fishData.flowFactor + $FishBuffNode.get_buff('flowfactor'))
			
	if state == fishState.hooked: #if the fish is hooked 
		if is_instance_valid(hookedTo):
			var pp = hookedTo.global_transform.origin # get the hooks' location
			var lineLength = hookedAmount * hookedRadius + hookedRadiusOffset #make up the radius of the sphere around the player the fish can swim on
			var wanderpoint = global_transform.origin + (velocity + HelperScripts.random_vec3()) * 6.0 #a wanderpoint is a random point in the general direction the fish was already heading
			var pointonsphere = HelperScripts.nearest_point_on_sphere(pp, lineLength, wanderpoint) #use pointonsphere algorithm to find nearest point on sphere around player, the radius of the sphere is dependent on how much youve reeled the fish in!
			add_force(seek(pointonsphere, 256, 0, 0) * 0.8) #add the force
		
	if state == fishState.talking: #if the fish is reeled in
		var wanderpoint = global_transform.origin + (velocity + HelperScripts.random_vec3()) * 6.0
		add_force(seek(HelperScripts.nearest_point_on_sphere(hookedTo.global_transform.origin, 3, wanderpoint), 64, 0) * 1.2)
#		add_force(seek(hookedTo.global_transform.origin, 2) * 0.01)
	var fishSpeed = (fishData.speed + $FishBuffNode.get_buff('speed')) * GameplayConstants.maxFishSpeed
	var _collider = move_and_collide(velocity * fishSpeed * delta)
	emit_signal("velocity_out", velocity * fishSpeed)


func fish_flow(_flow, flowFactor): #makes the fish follow a noisepattern held by the flownode referenced in the flow variable
	var fv = flow_time(_flow)
	add_force(fv * flowFactor)
	if debug:
		$DEBUGflow.points = [global_transform.origin, global_transform.origin + fv * flowFactor]

func evade_wall(coldict):
	if coldict["collisionNormal"].is_normalized():
		var c = -velocity.reflect(coldict["collisionNormal"])
		var f = coldict["collisionNormal"]
#		f += c
#		f *= coldict["collisionFactor"]
		acceleration += f * 5.0

func bait(_bait, baitData): #called by bobbers when fish is hit by its emitter
	var attract = 0.0
	var baitprefs = fishData.baitPreference
	for type in baitData["type"]: #go through types in typearray
		if baitprefs.has(type): #check if fish has type preference
			attract += 1.0 #if it has, increment attract, making the attraction stronger and the chance for the fish to want to follow it bigger
	if baitprefs.size() > 0: #sometimes a fish has no preference for some reason ???
		var baitMatch = attract / float(baitprefs.size())
		if baitMatch > randf():
			var stop = rand_range(0.1, 1.0)
			var factorFactor = rand_range(2.0, 3.0)
			var distanceFact = (_bait.global_transform.origin - global_transform.origin).length() / (baitData["smellStrength"] * GameplayConstants.maxBaitRadius)
			baitNode = _bait
			var mover = MoverResource.new(4.0, baitMatch * attract * factorFactor, 36, 36, stop, FishEnums.outcomes.seek, true, 7)
			var moverInstance = MoverInstance.new()
			moverInstance.moverResource = mover
			moverInstance.body = baitNode
			moverInstance.time = 4.0
			add_mover(moverInstance)

func hooked(_hook): #called when fish is hooked! that is to say, after the fish nibbled the bait and the nibblenode succeeded
	state = fishState.hooked
	hookedTo = _hook #hookedTo is used by the fish to calculate where to swim around frantically in the hooked state
	emit_signal("hooked", self)

func start_play(): #called when the player presses the accept button after reeling in the fish
	state = fishState.talking
	emit_signal("start_play") #starts talkmanager node
	
func release(): #called when the player presses the release button after reeling in the fish, resets some vars and sets state to default
	state = fishState.default
	hookedTo = null
	hookedAmount = 1
	emit_signal("brokefree")
	
func nibble():
	pass

func nibble_ignore():
	pass

func added_to_flock(): #called from shipflockmanager when fish is added to shipflock
	animationPlayer.play("added_to_flock")

func talk_over(win):
	if win == true:
		caught()
	else:
		state = fishState.default
		emit_signal("brokefree")

func reeled_in(_f = self):
	clear_movers_rigorous()
	velocity = Vector3.ZERO
	emit_signal("reeledin")
	state = fishState.talking
	var _nibbleNode = TimedInput.new(preload("res://assets/resources/choices/FishPlayChoice.tres"), self, "start_play", "release")

func netted(netter):
	hookedTo = netter
	velocity = Vector3.ZERO
	emit_signal("reeledin")
	state = fishState.talking
	var _nibbleNode = TimedInput.new(preload("res://assets/resources/choices/FishPlayChoice.tres"), self, "start_play", "release")

func broke_free(_f = self):
	emit_signal("brokefree")
	state = fishState.default

func caught():
	state = fishState.default
	fishData.caught = true
	
	emit_signal("caught", self)

func _on_MoverNode_done_iterating(vel):
	targetVelocity = vel

func _on_ResponseNode_mover_out(moverInstance : MoverInstance):
	add_mover(moverInstance)

func _on_FishFishTalkManager_talk_over(win):
	talk_over(win)

func set_active(truefalse):
	if truefalse:
		activate_fish()
	else:
		deactivate_fish()

func activate_fish():
	state = fishState.default
	emit_signal("fish_activated")

func deactivate_fish():
	state = fishState.stasis
	emit_signal("fish_deactivated")

func set_fish_data(newFishData : FishData):
	newFishData.scene = self
	fishData = newFishData

func sing():
	$FishSingNode.run()
