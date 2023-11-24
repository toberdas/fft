extends Spatial

var player
var ship
var saveGame
var map = null

const playerScene = preload("res://scenes/maingame/player/PlayerNode.tscn")
const shipScene = preload("res://scenes/ship/Ship.tscn")

signal savegame_out
signal map_out
signal map_ready
signal player_out
signal world_loaded

func _ready():
	pass

func start_world():
	GlobalSingleton.register_node(self)
	if map:
		emit_signal("map_out", map)
		GlobalSingleton.currentMap = map
	if saveGame:
		emit_signal("savegame_out", saveGame)

func load_from_savegame(savegame):
	ItemData.itemAtlasResource = savegame.itemAtlasResource
	saveGame = savegame
	map = saveGame.worldMap
	emit_signal("map_ready")

func put_player_on_ship():
	var startTransform = saveGame.shipResource.savedTransform
	startTransform.origin += Vector3(0,100,5)
	saveGame.playerResource.savedTransform = startTransform

func _on_MapEntityManager_entities_loaded():
	emit_signal("world_loaded")
	if saveGame.isNewGame:
		if saveGame.shipResource:
			var shipStartTransform = Transform()
			var startPoint = Vector2(0.5,0.5) * GameplayConstants.worldSize
			startPoint = Vector3(startPoint.x + 100.0, 100.0, startPoint.y + 100.0)
			shipStartTransform.origin = startPoint
			saveGame.shipResource.savedTransform = shipStartTransform
		if saveGame.playerResource:
			put_player_on_ship()
	if saveGame.playerResource:
		player = playerScene.instance()
		player.playerResource = saveGame.playerResource
		player.saveGame = saveGame
		GlobalSingleton.player = player
		add_child(player)
		emit_signal("player_out", player)
	if saveGame.shipResource:
		ship = shipScene.instance()
		ship.shipResource = saveGame.shipResource
		ship.upgradeCollectionResource = saveGame.upgradeCollectionResource
		ship.saveGame = saveGame
		add_child(ship)
