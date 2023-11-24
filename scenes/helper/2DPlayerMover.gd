extends Node2D
class_name TwoDPlayerMover

var moveInput = Vector2.ZERO
export var moveSpeed = 400.0
export var interPolateSpeed = 7.0
export var movementActive = true

func _process(delta):
	if movementActive:
		moveInput = moveInput.linear_interpolate(get_input(), interPolateSpeed * delta)
		move(moveInput, delta, moveSpeed)
	
func get_input():
	var mi = Vector2.ZERO
	mi.x = Input.get_action_strength("moveright") - Input.get_action_strength("moveleft")
	mi.y = Input.get_action_strength("movedown") - Input.get_action_strength("moveup")
	mi = mi.normalized()
	return mi

func move(_moveInput : Vector2, delta : float, speed : float):
	position += moveInput * speed * delta
