extends Control

const mapEntityScene = preload("res://scenes/ui/MapEntityScene.tscn")
const mapPlayerScene = preload("res://scenes/ui/MapPlayerScene.tscn")
var mapPlayerNode = null
var saveGame : SaveGame

var displayedList = []

export(NodePath) var mapRect

func _ready():
	mapRect = get_node(mapRect)

func added_to_menu():
	populate_map_from_savegame(saveGame)

func closed_in_menu():
	remove_map_nodes()

func populate_map_from_savegame(_savegame : SaveGame):
	if _savegame:
		saveGame = _savegame
		var playerResource : PlayerResource = saveGame.playerResource
		var worldMap : WorldMap = saveGame.worldMap
		for save in worldMap.allEntities:
			if save.discovered:
				add_point_to_map(save)
		if GlobalSingleton.player:
			mapPlayerNode = mapPlayerScene.instance()
			mapRect.add_child(mapPlayerNode)

func add_point_to_map(mapEntitySave):
	var mapEntityNode = mapEntityScene.instance()
	mapEntityNode.mapEntitySave = mapEntitySave
	mapEntityNode.position = mapEntitySave.point * mapRect.rect_size
	mapRect.add_child(mapEntityNode)
	displayedList.append(mapEntityNode)

func _process(delta):
	if GlobalSingleton.player && mapPlayerNode:
		var po = GlobalSingleton.player.global_transform.origin
		po = Vector2(po.x, po.z)
#		var lp = po.posmodv(GameplayConstants.worldSize) / GameplayConstants.worldSize
		var lp = po / GameplayConstants.worldSize
		mapPlayerNode.position = lp * mapRect.rect_size
	for node in displayedList:
		node.position = node.mapEntitySave.point * mapRect.rect_size

func remove_map_nodes():
	for child in mapRect.get_children():
		child.queue_free()
	displayedList = []


func _on_Player_savegame_out_at_ready(savegame):
	saveGame = savegame
