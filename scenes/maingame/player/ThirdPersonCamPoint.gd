extends Spatial


func _process(_delta):
	if get_parent().currentState == get_parent().state.strafing:
		transform.origin = Vector3(1.0,0.0,0.0)
	else:
		transform.origin = Vector3(0.0,0.0,0.0)
