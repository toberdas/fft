extends Spatial
class_name FlockManager

const fishPerContainer = 12
const fishScene = preload("res://scenes/fish/FishNode.tscn")
const cooldownPerFish = 0.1639

var flockContainers = []
var currentFlockIndex = 0

var fillFlock = {}
var fishDict = {}
var fishCaptureResource : FishCaptureResource

var cooldown = 0.0

signal flock_filled
signal fish_added_to_flock

export var saves = true

func _ready():
	for child in get_children():
		if child is FlockPath:
			flockContainers.append(child)

func _process(delta):
	if fillFlock.empty():
		pass
	else:
		cooldown -= delta
		if cooldown <= 0.0:
			cooldown = cooldownPerFish
			var k = fillFlock.keys()[0]
			add_fish_to_flock(fillFlock[k])
			fillFlock.erase(k)

func add_fish_to_flock(fish):
	if !fishCaptureResource :
		fishCaptureResource = FishCaptureResource.new()
	if saves:
		fishCaptureResource.add_from_fish(fish)
	HelperScripts.switch_parent_keep_transform(fish, get_tree().get_root())
	add_fish_to_dict(fish)
	emit_signal_to_fish(fish)
	var flockContainer = flockContainers[currentFlockIndex]
	if flockContainer.add_to_flock(fish) >= fishPerContainer:
		increment_flock_index_wrapping()
		emit_signal("flock_filled")
	emit_signal("fish_added_to_flock", fish)

func load_fish_in_flock(fish):
	add_fish_to_dict(fish)
	var flockContainer = flockContainers[currentFlockIndex]
	if flockContainer.add_to_flock(fish) >= fishPerContainer:
		increment_flock_index_wrapping()

func add_fish_to_fill_flock(fish):
	fillFlock[fish.name] = fish

func add_fish_to_dict(fish):
	fishDict[fish.name] = fish

func emit_signal_to_fish(fish):
	fish.added_to_flock()
	
func make_fish_from_capture_resource(captureResource : FishCaptureResource):
	var fishDataArray = captureResource.get_data_list()
	for fishData in fishDataArray:
		var fishInstance = fishScene.instance()
		fishData.brain.go_to_caught_state()
		fishInstance.fishData = fishData
		get_tree().get_root().add_child(fishInstance) ##TODO andere manier vinden om vissen aan world kind te maken.
		fishInstance.global_transform.origin = global_transform.origin + HelperScripts.random_vec3() * 1.0
		load_fish_in_flock(fishInstance)

func increment_flock_index_wrapping():
	currentFlockIndex = wrapi(currentFlockIndex + 1, 0, flockContainers.size())

func free_all_fish():
	for key in fishDict.keys():
		var fish : Fish = fishDict[key]
		fish.fishData.brain.go_to_rest_state()
		fish.clear_movers_rigorous()
	fishCaptureResource.release_all_fish()

#func accept_player_flock(flockdict): VOOR SCHIP
#	if !flockdict.empty():
#		currentFlockToFill = flockdict
