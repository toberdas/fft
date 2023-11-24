extends Node

export(PackedScene) var islandNode

var loadedIslands = {}
var player = null
var loadCount = 0
var targetLoadCount = 0

signal islands_loaded

func check_and_load(pointData):
	var save = pointData["save"]
	var mappoint = save.point
	var realpoint = pointData["realPoint"]
	if !loadedIslands.has(mappoint):
		var island : IslandNode = load_island(realpoint, save)
		loadedIslands[mappoint] = island
		island.connect("island_loaded", self, "island_loaded")


func load_island(realpoint, save):
	var pi = islandNode.instance()
	add_child(pi)
	pi.global_transform.origin.x = realpoint.x
	pi.global_transform.origin.z = realpoint.y
	pi.init(save, player)
	pi.connect("start_deinitialize", self, "unload")
	return pi

func island_loaded():
	loadCount += 1
	if loadCount == targetLoadCount:
		emit_signal("islands_loaded")


func unload(islandpoint):
	loadedIslands.erase(islandpoint)

func _on_World_player_out(_player):
	player = _player


func _on_MapChecker_points_in_radius(loadPointArray):
	loadCount = 0
	targetLoadCount = loadPointArray.size() 
	for i in range(loadPointArray.size()):
		check_and_load(loadPointArray[i])
		
	
