
#
extends Node
class_name MapEntityManager

var loadedEntities = {}
var player = null
var loadCount = 0
var targetLoadCount = 0
var entitySceneDict = {
	"Island" : preload("res://scenes/island/IslandNode.tscn"),
	"Flock" : preload("res://scenes/fish/Flock.tscn"),
	"FishIsland" : preload("res://scenes/fishisland/FishIslandScene.tscn")
}

signal entities_loaded

func check_and_load(pointData):
	var save = pointData["save"]
	var mappoint = save.point
	var realpoint = pointData["realPoint"]
	if !is_entity_loaded(save):
		
		var entity = load_entity(realpoint, save)
		loadedEntities[save] = {
			'entityNode' : entity,
			'inRange' : true
		}
		
	loadedEntities[save]['inRange'] = true
		

func load_entity(realpoint, save):
	var pi = entitySceneDict[save.sceneName].instance()
	add_child(pi)
	pi.connect("loaded", self, "entity_loaded")
	pi.global_transform.origin.x = realpoint.x
	pi.global_transform.origin.z = realpoint.y
	pi.init(save)
#	pi.connect("start_deinitialize", self, "unload")
	return pi

func entity_loaded():
	loadCount += 1
	if loadCount == targetLoadCount - 1:
		emit_signal("entities_loaded")

func unload(save):
	if loadedEntities[save].has('entityNode'):
		loadedEntities[save]['entityNode'].queue_free()
	loadedEntities.erase(save)

func is_entity_loaded(entitySave):
	return loadedEntities.has(entitySave)

func _on_World_player_out(_player):
	player = _player

func load_points(pointArray):
	for entityKey in loadedEntities.keys():
		if loadedEntities[entityKey]['inRange'] == false:
			unload(entityKey) 
	for entityKey in loadedEntities.keys():
		loadedEntities[entityKey]['inRange'] = false 
	loadCount = 0
	targetLoadCount = pointArray.size() 
	for i in range(pointArray.size()):
		check_and_load(pointArray[i])

func _on_MapChecker_points_in_radius(loadPointArray):
	load_points(loadPointArray)
		
