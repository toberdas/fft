extends Node


var map : WorldMap
var active = false


func _process(delta):
	if active:
		map.update()


func _on_World_world_loaded():
	active = true


func _on_World_map_out(_map):
	map = _map
