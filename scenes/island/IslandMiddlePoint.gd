extends MedianCalculator

var middlePoint

func _on_IslandCellularNode_cube_added(cube):
	middlePoint = add_value(cube.global_transform.origin)
	global_transform.origin = middlePoint
