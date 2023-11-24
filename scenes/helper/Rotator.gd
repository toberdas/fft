extends Spatial
tool

export(Vector3) var axis
export(int, -1, 1) var direction
export var targetSpeed = 1.0
export(bool) var on = false

var speed = 3.0

func _ready():
	speed = targetSpeed

func _process(delta):
	if on:
		if axis != Vector3.ZERO:
			rotate(axis.normalized(), delta * speed * direction)
		if speed != targetSpeed:
			speed = lerp(speed, targetSpeed, delta * 3)
