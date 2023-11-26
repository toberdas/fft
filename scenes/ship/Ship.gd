extends KinematicBody

export var heightDelta = .4
export var yawSpeed = 0.4
export var tiltSpeed = 0.4
export var steerSpeed = 12.8
export var knotSpeed = 24.0
export var quatDelta = .2

var targetSteerAngle = 0.0
var currentSteerAngle = 0.0
var speed = 0.0
var targetSpeed = 0.0
var mass
var targetHeight = 0.0
var targetBasis = Basis()
var targetTransform = Transform()
var deltaMod = 0.5
var velocity = Vector3.ZERO

var yaw = 0.0
var tilt = 0.0
var flying = false
var takeOffBuffer = 48
var takeOffBufferCount = 0

var targetYaw = 0.0
var targetTilt = 0.0
var yawSecondOrder : SecondOrderDynamicsFloat
var tiltSecondOrder : SecondOrderDynamicsFloat

var shipResource
var upgradeCollectionResource
var saveGame
var player = null

signal speedIncrease
signal fly_start
signal fly_end

signal ship_loaded
signal upgrade_collection_loaded
signal save_game_out

func _ready():
	GlobalSingleton.ship = self
	yawSecondOrder = SecondOrderDynamicsFloat.new(0.9,0.8,1.6, yaw)
	tiltSecondOrder = SecondOrderDynamicsFloat.new(0.9,0.4,0.2, tilt)
	targetHeight = global_transform.origin.y
	velocity = Vector3.ZERO
	if shipResource:
		global_transform = shipResource.savedTransform
		emit_signal("ship_loaded", shipResource)
	if upgradeCollectionResource:
		emit_signal("upgrade_collection_loaded", upgradeCollectionResource)
	if saveGame:
		emit_signal("save_game_out", saveGame)

func _process(delta):
	if takeOffBufferCount > 0:
		takeOffBufferCount -= 1
	targetSteerAngle = move_toward(targetSteerAngle, 0.0, delta * deltaMod)
	currentSteerAngle = move_toward(currentSteerAngle, targetSteerAngle, delta * deltaMod)
	targetYaw = move_toward(targetYaw, 0.0, delta * deltaMod)
	targetTilt = move_toward(targetTilt, 0.0, delta * deltaMod)
	yaw = yawSecondOrder.update(delta, targetYaw)
	tilt = tiltSecondOrder.update(delta, targetTilt)
	var oldspeed = speed
	speed = lerp(speed, targetSpeed, delta * deltaMod)
	emit_signal("speedIncrease", oldspeed, speed) #emit for engine to compute sound
#	rotate_object_local(transform.basis.y, currentSteerAngle * steerSpeed)
	targetBasis = targetBasis.rotated(targetBasis.y, currentSteerAngle * steerSpeed * delta)
	targetBasis = targetBasis.rotated(targetBasis.z, yaw * yawSpeed * delta)
	targetBasis = targetBasis.rotated(targetBasis.x, tilt * tiltSpeed * delta)

	if flying:
		targetHeight = global_transform.origin.y
	global_transform.origin.y = move_toward(global_transform.origin.y, targetHeight, heightDelta)
	
	var quat = transform.basis.get_rotation_quat().slerp(targetBasis.get_rotation_quat(), delta)
	transform.basis = Basis(quat)
	velocity = transform.basis.z * speed * knotSpeed
#	if !flying:
#		velocity.y = (targetHeight - global_transform.origin.y)
	move_and_slide(velocity)
	
	if shipResource:
		shipResource.savedTransform = global_transform

func _unhandled_input(event):
	if Input.is_action_just_pressed("l3"):
		start_flying()
		

func start_flying():
	if check_if_can_fly():
		emit_signal("fly_start")
		GlobalSingleton.player.fly_start()
		set_fly_timer()
		targetHeight = global_transform.origin.y
		targetBasis = transform.basis
		flying = true
		targetSpeed = 5.0
		takeOffBufferCount = takeOffBuffer
		targetSteerAngle = 0.0
		currentSteerAngle = 0.0
		$SeaBalanceNode.heightMax = 0.0
		$SeaBalanceNode.heightMin = 0.0
		$SeaBalanceNode.set_bobber_active(false)

func land():
	emit_signal("fly_end")
	GlobalSingleton.player.fly_end()
	flying = false
	yaw = 0.0
	tilt = 0.0
	targetHeight = global_transform.origin.y
	targetBasis = transform.basis
	$SeaBalanceNode.heightMax = 24.0
	$SeaBalanceNode.heightMin = -24.0
	$SeaBalanceNode.set_bobber_active(true)

func check_if_can_fly():
	if saveGame:
		return saveGame.upgradeCollectionResource.get_upgrade("ship").check_if_equip_full("Take off")
	else:
		return true

func set_fly_timer():
	if saveGame:
		if saveGame.upgradeCollectionResource.get_upgrade("ship").check_if_equip_full("Fly forever"):
			return
		if saveGame.upgradeCollectionResource.get_upgrade("ship").check_if_equip_full("Fly higher"):
			$FlyTimer.start(12)
		if saveGame.upgradeCollectionResource.get_upgrade("ship").check_if_equip_full("Take off"):
			$FlyTimer.start(6)
#	$FlyTimer.start(6)

func update_steering(angle, forward):
	if flying:
		targetYaw = -angle
		targetTilt = forward
	else:
		targetSteerAngle = angle
		targetSpeed = clamp(targetSpeed + forward,0.0,1.0)

func _on_SeaBalanceNode_emit_data(data):
	if !flying:
		targetHeight = data["height"]
		targetBasis = data["basis"]


func _on_LandSeaChecker_submerged():
	if flying && takeOffBufferCount <= 0:
		land()
		targetSpeed = 1.0


func _on_FlyTimer_timeout():
	if flying:
		land()
		targetSpeed = 1.0


func _on_ParentArea_child_unparented(_child):
	if flying:
		land()
		targetSpeed = 0.0
	else:
		targetSpeed = 0.0
