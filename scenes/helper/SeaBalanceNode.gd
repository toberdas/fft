extends Spatial



signal emit_data

#export var targetUpVelocity = 12.0 setget set_target_up_velocity
#export var targetDownVelocity = -12.0 setget set_target_down_velocity
#
#export var upAccel = 20.0 setget set_up_acceleration
#export var downAccel = 20.0 setget set_down_acceleration
 
onready var bobber_front_right = $BobberFrontRight
onready var bobber_front_left = $BobberFrontLeft
onready var bobber_back_left = $BobberBackLeft
onready var bobber_back_right = $BobberBackRight

onready var anchor_front_right = $AnchorFrontRight
onready var anchor_front_left = $AnchorFrontLeft
onready var anchor_back_left = $AnchorBackLeft
onready var anchor_back_right = $AnchorBackRight

export(bool) var setOwnBasis
export(bool) var setOwnHeight
export(float) var moveMod = 2
export(float) var heightMin = -36.0
export(float) var heightMax = 36.0

var height = 0.0
var bobbers = []

func _ready():
	bobbers = [bobber_front_right, bobber_front_left, bobber_back_right, bobber_back_left]
	for bobber in bobbers:
		bobber.set_as_toplevel(true)
#	set_target_up_velocity(targetUpVelocity)
#	set_target_down_velocity(targetDownVelocity)
#	set_up_acceleration(upAccel)
#	set_down_acceleration(downAccel)
	
func _process(delta):
	set_bobber_positions()
	height = calculate_height()
	var basis = calculate_basis()
	emit_signal("emit_data", {
		"height" : height,
		"basis" : basis
	})
	if setOwnHeight:
		global_transform.origin.y = move_toward(global_transform.origin.y, height, delta * moveMod)
	if setOwnBasis:
		transform.basis = transform.basis.slerp(basis, delta * moveMod)

func calculate_height():
	var _height = 0.0
	for bobber in bobbers:
		_height += bobber.global_transform.origin.y
	_height /= 4
	return _height

func calculate_basis():
	var basis = global_transform.basis
	var frontRightBasis = calculate_front_right()
	var frontLeftBasis = calculate_front_left()
	var backRightBasis = calculate_back_right()
	var backLeftBasis = calculate_back_left()
	return get_mean_basis_from_list([frontRightBasis, frontLeftBasis, backRightBasis, backLeftBasis]).orthonormalized()
#	return get_mean_basis_from_list([frontRightBasis]).orthonormalized()


func get_mean_basis_from_list(basisList):
	var cumX = Vector3()
	var cumY = Vector3()
	var cumZ = Vector3()
	for basis in basisList:
		cumX += basis.x
		cumY += basis.y
		cumZ += basis.z
	return Basis(cumX/basisList.size(), cumY / basisList.size(), cumZ / basisList.size())


func set_bobber_positions():
	bobber_front_right.global_transform.origin.x = anchor_front_right.global_transform.origin.x
	bobber_front_right.global_transform.origin.z = anchor_front_right.global_transform.origin.z
	bobber_front_left.global_transform.origin.x = anchor_front_left.global_transform.origin.x
	bobber_front_left.global_transform.origin.z = anchor_front_left.global_transform.origin.z
	bobber_back_right.global_transform.origin.x = anchor_back_right.global_transform.origin.x
	bobber_back_right.global_transform.origin.z = anchor_back_right.global_transform.origin.z
	bobber_back_left.global_transform.origin.x = anchor_back_left.global_transform.origin.x
	bobber_back_left.global_transform.origin.z = anchor_back_left.global_transform.origin.z
	bobber_front_right.global_transform.origin.y = clamp(bobber_front_right.global_transform.origin.y, global_transform.origin.y + heightMin, global_transform.origin.y +  heightMax)
	bobber_front_left.global_transform.origin.y = clamp(bobber_front_left.global_transform.origin.y, global_transform.origin.y + heightMin, global_transform.origin.y +  heightMax)
	bobber_back_right.global_transform.origin.y = clamp(bobber_back_right.global_transform.origin.y, global_transform.origin.y + heightMin, global_transform.origin.y +  heightMax)
	bobber_back_left.global_transform.origin.y = clamp(bobber_back_left.global_transform.origin.y, global_transform.origin.y + heightMin, global_transform.origin.y +  heightMax)

func calculate_front_right():
	var virtualBackRight = anchor_back_right.global_transform.origin
	var virtualFrontLeft = anchor_front_left.global_transform.origin
	var forwardVector = (virtualBackRight - bobber_front_right.global_transform.origin).normalized()
	var rightVector = -(virtualFrontLeft - bobber_front_right.global_transform.origin).normalized()
	var upVector = forwardVector.cross(rightVector)
	return Basis(rightVector, upVector, forwardVector)

func calculate_front_left():
	var virtualBackLeft = anchor_back_left.global_transform.origin
	var virtualFrontRight = anchor_front_right.global_transform.origin
	var forwardVector = (virtualBackLeft - bobber_front_left.global_transform.origin).normalized()
	var rightVector = (virtualFrontRight - bobber_front_left.global_transform.origin).normalized()
	var upVector = forwardVector.cross(rightVector)
	return Basis(rightVector, upVector, forwardVector)

func calculate_back_right():
	var virtualFrontRight = anchor_front_right.global_transform.origin
	var virtualBackLeft = anchor_back_left.global_transform.origin
	var forwardVector = (bobber_back_right.global_transform.origin - virtualFrontRight).normalized()
	var rightVector = -(virtualBackLeft - bobber_back_right.global_transform.origin).normalized()
	var upVector = forwardVector.cross(rightVector)
	return Basis(rightVector, upVector, forwardVector)

func calculate_back_left():
	var virtualFrontLeft = anchor_front_left.global_transform.origin
	var virtualBackRight = anchor_back_right.global_transform.origin
	var forwardVector = (bobber_back_left.global_transform.origin - virtualFrontLeft).normalized()
	var rightVector = (virtualBackRight - bobber_back_left.global_transform.origin).normalized()
	var upVector = forwardVector.cross(rightVector)
	return Basis(rightVector, upVector, forwardVector)

func set_bobber_active(boo : bool):
	for bobber in bobbers:
		bobber.active = boo

#func set_target_up_velocity(val):
#	targetUpVelocity = val
#	for bobber in bobbers:
#		bobber.targetUpVelocity = val
#
#func set_target_down_velocity(val):
#	targetDownVelocity = val
#	for bobber in bobbers:
#		bobber.targetDownVelocity = val
#
#func set_up_acceleration(val):
#	upAccel = val
#	for bobber in bobbers:
#		bobber.upAccel = val
#
#func set_down_acceleration(val):
#	downAccel = val
#	for bobber in bobbers:
#		bobber.downAccel = val
