extends Node

var islandSave : IslandSave

func is_treasure_taken():
	return islandSave.treasureFound

func _on_IslandNode_start_initialize(_islandSave):
	islandSave = _islandSave


