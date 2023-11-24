extends Spatial


func get_2d_direction(fish):
	var v3 = (global_transform.origin - fish.global_transform.origin).normalized()
	var rad = Vector2(v3.x, v3.y).angle()
	$Arrow.rotation = rad
#	return Vector2(v3.x, v3.y)
	
