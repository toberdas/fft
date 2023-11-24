extends NodeTracker


var oldLoadPosition = 0

var cellWidth

signal load_movement

func _process(delta):
	var newLocation = get_node_global_position()
	var loadPosition = get_load_position_from_location(newLocation.x)
	var loadMovement = get_load_movement(loadPosition, oldLoadPosition)
	oldLoadPosition = loadPosition
	emit_signal("load_movement", loadMovement)

func get_load_movement(newPosition, oldPosition):
	return newPosition - oldPosition

func get_load_position_from_location(location):
	return floor(location / cellWidth)


func _on_PlatformGenerator_initialize(data):
	cellWidth = data.screenScale
