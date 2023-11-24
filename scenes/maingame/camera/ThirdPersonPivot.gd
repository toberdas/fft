extends CameraGetup #is a following node, followss player around
#this is NOT the camera itself, this is the contraption the camera is attached to when in 3rd person platformer mode!

onready var follow = $Path/Follow
onready var third_person_point = $Path/Follow/ThirdPersonPoint


var targetZoom = 0
var zoom = 0
export var minAngle = -17
export var maxAngle = 17
export var zoomSpeed = 1.0
export var turnSpeed = 2

func _process(_delta):
	$RayCast.cast_to = follow.transform.origin
	var rayCol = $RayCast.get_collider()
	if rayCol:
		third_person_point.global_transform.origin = $RayCast.get_collision_point()
	else:
		third_person_point.global_transform.origin = follow.global_transform.origin
func _ready():
	mode = "origin"
	
func move_camera(delta):
	targetZoom = clamp(targetZoom - camInput.y * zoomSpeed * delta, 0, 1) #update target zoom, unit offset between 0 and 1
	zoom = lerp(zoom, targetZoom, 10 * delta) #update current zoom using targetzoom
	var po = $Path/Follow.unit_offset 
	$Path/Follow.set_unit_offset(zoom) #use current zoom to set pathfollow offset
	$Path/Follow.set_rotation_degrees(Vector3(minAngle + (-minAngle + maxAngle) * po,0,0)) #hacky way to have camera pointed down 17 degrees on 0 zoom and 16 degrees up on 1 zoom
	followInput = followInput.linear_interpolate(camInput, 10 * delta)
	rotate_y(-followInput.x * delta * turnSpeed)
	
