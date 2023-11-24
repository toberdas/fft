extends Spatial

const islandScene = preload("res://scenes/island/IslandNode.tscn")
var islandResource = null
var island = null

func _on_Test_test1():
	var islandSave = IslandSave.new()
	islandSave.islandSeed = hash(randf())
#	islandResource = IslandResource.new()
#	islandResource.generate_at_once()
	var island = load_island()
	island.init(islandSave)
	

func load_island():
	if island:
		island.queue_free()
	island = islandScene.instance()
	add_child(island)
	return island
