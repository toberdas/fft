extends KinematicBody2D
class_name TwoDKinematicPlayerMover

var moveInput = Vector2.ZERO
export var moveSpeed = 400.0
export var interPolateSpeed = 7.0

func _process(delta):
	moveInput = moveInput.linear_interpolate(get_input(), interPolateSpeed * delta)
	move(moveInput, delta, moveSpeed)
	
func get_input():
	var mi = Vector2.ZERO
	mi.x = Input.get_action_strength("moveright") - Input.get_action_strength("moveleft")
	mi.y = Input.get_action_strength("movedown") - Input.get_action_strength("moveup")
	mi = mi.normalized()
	return mi

func move(_moveInput : Vector2, delta : float, speed : float):
	var _vel = move_and_slide(_moveInput * delta * speed)

