extends Node

signal speed_out
var currentSpeed = 0.0

var momentum : float = 0.0
var targetMomentum : float = 0.0

var direction : Vector3
var targetDirection : Vector3

func _process(delta):
	momentum = lerp(momentum, targetMomentum, delta * 10)
	direction.move_toward(targetDirection, delta)
	
func _on_Fish_velocity_out(velocity : Vector3):
	var velocityLength = velocity.length()
	var newSpeed = velocityLength * 3.0
	var dot = direction.dot(velocity)
	if newSpeed - currentSpeed > 2.0 or dot < 0.2:
		targetMomentum = newSpeed
		currentSpeed = newSpeed
	else:
		targetMomentum = 0.0
	emit_signal("speed_out", momentum)
