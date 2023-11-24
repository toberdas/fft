extends Node


var saveGame : SaveGame


func _on_Player_savegame_out_at_ready(_saveGame):
	saveGame = _saveGame
