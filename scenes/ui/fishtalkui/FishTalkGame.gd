extends Control


var gameController = preload("res://scenes/minigames/GameController.tscn")
var fishData = null

signal switch_screen_out
signal game_done
signal exit_talk


func _enter_tree():
	start_game_from_data(fishData)

func start_game_from_data(_fishData):
	var gc = gameController.instance()
	if _fishData:
		gc.fishData = _fishData
	else:
		gc.fishData = FishData.new()
		gc.fishData.generate()
	add_child(gc)
	gc.connect("gamingdone", self, "game_is_done")

func game_is_done(win):
	if win == 1:
		fishData.gameWon = true
		emit_signal("switch_screen_out", "welcome")
	else:
		emit_signal("switch_screen_out", "welcome")
