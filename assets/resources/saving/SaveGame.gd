extends Resource
class_name SaveGame

export var playerResource : Resource
export var shipResource : Resource
export var mapSeed = 0
export var itemAtlasResource : Resource
export var islandCount = 6
export var isNewGame = false
export var caughtFishList = []
export var worldMap : Resource
export var upgradeCollectionResource : Resource

func _init(_islandCount = 1280):
	islandCount = _islandCount

func new_game():
	randomize()
	isNewGame = true
	mapSeed = hash(randf())
	playerResource = PlayerResource.new()
	playerResource.first_creation()
	shipResource = ShipResource.new()
	shipResource.first_creation()
	itemAtlasResource = ItemAtlas.new()
	worldMap = WorldMap.new()
	worldMap.seeed = mapSeed
	worldMap.generate()
	upgradeCollectionResource = load("res://assets/resources/upgrades/specific/MainUpgradeCollection.tres")

func from_load(loadedResource):
	isNewGame = false
	playerResource = PlayerResource.new()
	playerResource.from_load(loadedResource.playerResource)
	mapSeed = loadedResource.mapSeed
	islandCount = loadedResource.islandCount
	itemAtlasResource = ItemAtlas.new()
	itemAtlasResource.from_load(loadedResource.itemAtlasResource)
	shipResource = ShipResource.new()
	shipResource.from_load(loadedResource.shipResource)
	upgradeCollectionResource = loadedResource.upgradeCollectionResource
	worldMap = loadedResource.worldMap
	pass
	
func check_if_fish_is_caught_by_seed(_seed):
	var rv = null
	if shipResource:
		rv = shipResource.fishCaptureResource.get(_seed)
	return rv
