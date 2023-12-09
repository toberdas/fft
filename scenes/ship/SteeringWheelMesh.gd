extends Spatial

var rot = 0.0
var currentRot = 0.0

func _process(delta):
	rot = move_toward(rot, 0.0, delta)
	currentRot = move_toward(currentRot, rot, delta * 2)
	rotate_z(-currentRot * delta)


func _on_SteeringWheel_steerUpdate(steerX, _steerY):
	rot = steerX
