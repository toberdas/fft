extends Spatial

var averagePos = Vector3.ZERO #used for cheap flock calculations, where only the flock node calculate all the averages used in flocking
var averageVel = Vector3.ZERO
var tick = 0
var tickTime = 0.01 #used to make it so flock doesnt update averages every frame, making it less heavy processing

export(PackedScene) var fish
export var cheap = true #bool to check if flock does cheap or expensive flocking algo
export(Resource) var mover

var spawning = false
var fishAmount = 7
var fishIndex = 0
const flockData = preload("res://assets/resources/fish/FlockData.tres")
var fishArray = []
var flockSave : FlockSave

var singing = false
onready var  followSpatial = $Spatial

signal fish_added
signal done_spawning
signal fish_from_flock
signal fish_hooked
signal fish_released
signal loaded
signal start_deinitialize


func _process(_delta):
	if spawning:
		fishIndex = spawn_fish_step(fishIndex, fishAmount)
		if fishIndex >= flockSave.fishSaves.size():
			spawning = false
#			emit_signal("done_spawning")
#			emit_signal("loaded")
		return
	if cheap:
		update_averages()
		cheap_move_fish()
	else:
		move_fish()
	if flockSave:
		var realPoint = flockSave.get_real_point()
		global_transform.origin.x = realPoint.x
		global_transform.origin.z = realPoint.y
	if singing:
		var randFish = HelperScripts.random_value_from_array(fishArray)
		randFish.sing()


func init(save):
	flockSave = save 
	seed(flockSave.flockSeed)
	if !flockSave.fishSavesGenerated:
		for i in range(fishAmount):
			var newFishSave = FishSave.new()
			newFishSave.fishSeed = hash(randf())
			newFishSave.foreignSeed = flockSave.flockSeed
			flockSave.fishSaves.append(newFishSave)
		flockSave.fishSavesGenerated = true
	spawning = true
	emit_signal("loaded")
	$Timer.wait_time = mover.time



func spawn_fish_step(i, _amount):

	var nf = fish.instance()
	var fishSave = flockSave.fishSaves[i]
	var newFishData = fishSave.generate_fish_data()
	nf.fishData = newFishData
	nf.fishSave = fishSave
	add_fish(nf)
	nf.set_as_toplevel(true)
	nf.global_transform.origin = $Spawnpoint.global_transform.origin
	nf.global_transform.origin += HelperScripts.random_vec3() * 2.0
	i += 1
	return i


func update_averages(): 
	var pos = Vector3.ZERO	
	var vel = Vector3.ZERO
	var i = 0
	for _fish in get_children():
		if _fish is Fish:
			vel += _fish.velocity
			pos += _fish.global_transform.origin
			i += 1
	averageVel = vel / i
	averagePos = pos / i 

func cheap_move_fish():
	for _fish in get_children():
		if _fish is Fish:
			if _fish.state == _fish.fishState.default:
				if !_fish.check_for_unique():
					_fish.cheapflock(self, flockData)
					_fish.add_force(_fish.seek($Spatial.global_transform.origin,256,3,1) * 0.5)
				

func move_fish():
	for _fish in get_children():
		if _fish is Fish:
			if _fish.state == _fish.fishState.default:
				_fish.flock(self)

func add_fish(nf):
	nf.flock = self
	nf.connect("caught", self, "fish_from_flock")
	nf.connect("hooked", self, "fish_hooked")
	nf.connect("brokefree", self, "fish_released")
	nf.connect("released", self, "fish_released")
	fishArray.append(nf)
	add_child(nf)
	emit_signal("fish_added", nf)

func fish_from_flock(_fish):
	flockSave.moving = true
	flockSave.fishSaves.erase(_fish.fishSave)
	emit_signal("fish_from_flock", _fish)

func fish_released():
	flockSave.moving = true
	emit_signal("fish_released")

func fish_hooked(_fish):
	flockSave.moving = false
	emit_signal("fish_hooked", _fish)

func add_mover_to_fish(_mover, target):
	for _fish in get_children():
		if _fish is Fish:
			var moverInstance = MoverInstance.new()
			moverInstance.body = target
			moverInstance.moverResource = _mover
			_fish.add_mover(moverInstance)

func _on_Timer_timeout():
	singing = not singing
	if flockSave:
		if flockSave.atTarget && flockSave.targetSave.node:
			var topCells = flockSave.targetSave.get_island_real_surfaces()
			if topCells.size() > 0:
				var newTarget = HelperScripts.random_value_from_array(topCells) + flockSave.targetSave.node.global_transform.origin
				followSpatial.global_transform.origin = newTarget
		else:
			followSpatial.transform.origin = Vector3(0,43,0)
		add_mover_to_fish(mover, followSpatial)


