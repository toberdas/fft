extends Control


var connections
var walls

export var mazeScale = 48
export var offset = Vector2(124, 124)
export var pathThickness = 36.0

func _draw():

	for connection in connections:
		var dir = connection[1] - connection[0]
		draw_line(connection[0] * mazeScale + offset, connection[1] * mazeScale + offset + dir * pathThickness / 2.0, Color.webmaroon, pathThickness, true)
