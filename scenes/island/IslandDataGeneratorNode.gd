extends Node

var islandSave : IslandSave
var islandResource : IslandResource

var generating = false

signal resource_generated

func _process(delta):
	if generating:
		if islandSave.generate_resource_step():
			generating = false
			islandResource = islandSave.islandResource
			emit_signal("resource_generated")

func start_generating(_islandSave : IslandSave):
	islandSave = _islandSave
	generating = true
