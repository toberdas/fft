extends Spatial

const worldScene = preload("res://scenes/maingame/worlds/World.tscn")
const saveGameResource = preload("res://assets/resources/saving/SaveGame.tres")

var currentSaveGame
var loader 

signal world_out

func emit_world(_world):
	emit_signal("world_out", _world)

func start_new_game():
	currentSaveGame = make_new_savegame()
	make_world(currentSaveGame)

func make_new_savegame():
	currentSaveGame = SaveGame.new()
	currentSaveGame.new_game()
	return currentSaveGame

func make_world(_saveGame):
	var world = worldScene.instance()
	world.connect("map_ready", self, "emit_world", [world])
	world.load_from_savegame(_saveGame)

func save_game():
#	currentSaveGame.take_over_path("user://save.res")
	var ok = ResourceSaver.save("user://save.res", currentSaveGame, 68)
	

func quick_load():
	start_load()

func start_load():
	$ThreadLoader.load_resource("user://save.res")

func _on_ThreadLoader_load_done(loadedResource):
	if loadedResource:
		currentSaveGame = SaveGame.new()
		currentSaveGame.from_load(loadedResource)
		make_world(currentSaveGame)
