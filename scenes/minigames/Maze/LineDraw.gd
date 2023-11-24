extends Control
class_name LineDraw

var pathArray = PoolVector2Array([])

func _init(pa):
	pathArray = pa
	_draw()

func _draw():
	if pathArray.size() > 2:
		draw_multiline(pathArray, Color.white, 1, true)

