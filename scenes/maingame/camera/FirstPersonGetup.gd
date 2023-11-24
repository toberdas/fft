extends CameraGetup


export var zoomSpeed = 1
export var turnSpeed = 2
export var minAngle = -1.0
export var maxAngle = 1.4

func _ready():
	mode = "origin"

func move_camera(delta):
	followInput = followInput.linear_interpolate(camInput, 10 * delta)
	point.rotate_x(-followInput.y * delta * turnSpeed)
	point.rotation.x = clamp(point.rotation.x, minAngle, maxAngle)
	rotate_y(-followInput.x * delta * turnSpeed)
	global_transform = global_transform.orthonormalized()

func activate(targetpoint):
	var temptrans = global_transform.looking_at(targetpoint, transform.basis.y)
	var rotvec = temptrans.basis.get_euler()
	set_rotation_degrees(Vector3(0,rad2deg(rotvec.y),0))
	point.set_rotation_degrees(Vector3(rad2deg(rotvec.x),0,0))
