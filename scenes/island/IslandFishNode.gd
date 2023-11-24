extends Spatial

export(PackedScene) var flockScene
export(PackedScene) var fishScene

const loadDistance = 300

var fishLoaded = false
onready var spawn_node = $"../IslandCellularNode/HighestPoint/SpawnNode"

var islandSave : IslandSave
var flockScenes = []
var fishScenes = []
var fishCollection = null

var fishCount = 0

signal fish_from_flock
signal fish_hooked
signal fish_released
signal fish_reeled_in
signal fish_caught
signal fish_loaded

func load_fish():
	emit_signal("fish_loaded")
	return
	for fishdata in fishCollection.fishDataArray:
		if fishdata.spawnPoint: #when island is empty :((
			if !islandSave.caughtFishSeedList.has(fishdata.fishSeed):
				var fs = fishScene.instance()
				var spat = Spatial.new()
				fs.fishData = fishdata
				fs.followPoint = spat
				spat.transform.origin = HelperScripts.random_value_from_array(fishdata.pointList)
				add_child(spat)
				add_child(fs)
				fs.global_transform.origin = spawn_node.global_transform.origin
				fs.connect("caught", self, "on_fish_caught")
				fs.connect("brokefree", self, "on_fish_broke_free")
				fs.connect("reeledin", self, "on_fish_reeled_in")
				fs.connect("hooked", self, "on_fish_hooked")
				fishScenes.append(fs)
				fishCount += 1
	fishLoaded = true
	emit_signal("fish_loaded")

func freeze_fish():
	set_fish_processing(false)

func unfreeze_fish():
	set_fish_processing(true)

func set_fish_processing(boo):
	for fish in fishScenes:
		fish.set_process(boo)
		fish.set_active(boo)
		fish.visible = boo

func _on_IslandNode_start_initialize(save):
	islandSave = save
	fishCollection = islandSave.islandResource.fishCollection
#	load_flocks()

func on_fish_caught(fish):
	islandSave.caughtFishSeedList.append(fish.fishData.fishSeed)
	fishCount -= 1
	emit_signal("fish_caught", fishCount)

func on_fish_broke_free():
	emit_signal("fish_released")

func on_fish_hooked(fish):
	emit_signal("fish_hooked")

func on_fish_reeled_in():
	emit_signal("fish_reeled_in")

func _on_IslandCellularNode_generation_done():
	load_fish()


func _on_PlayerTracker_player_distance_out(playerDistance):
	if playerDistance < loadDistance:
		unfreeze_fish()
	if playerDistance > loadDistance + 100:
		freeze_fish()
