extends KinematicBody
class_name Player

const DEBUG = true

export var fallSpeed = 12
export var moveSpeed = 300
export var strafeSpeed = 200
export var turnSpeed = 4.0
export var jumpSpeed = 15.0
export var maxFallSpeed = 40.0
export var grav = 30.0
export var inAirMod = 0.8
export var jumpBuffer = 0.2
export var doubleJumpBuffer = 6
export var coyoteSec = 0.3
export var debug = false
export var moveFactor = 0.3
export var maxVelocity = 7.0
export var drag = 16.0
export var jumpVelocityAdd = 1.2
export var combiJumpAdd = 0.6
export var combiGravMinus = 2
export var doubleJump = 1
export var maxFallVelocityLength = 2.0
export var emergeFrames = 6.0
export var buoyancy = 24.0
export var swimSpeed = 14.0
export var diveSpeed = 24.0

var playerResource : PlayerResource setget set_player_resource
var saveGame 

enum state{idle, accelerate, topspeed, brake, angling, strafing, jumping, reelinjump, dashload, dashing, inair, nibble, reelin, gaming, interacting, inmenu, inwater, limitless, onwall, walljumping, doublejump, reelinjump, attacked, investigating, underwater}
var immuneToAttackStates = [state.reelin, state.inmenu, state.nibble, state.gaming, state.interacting]
var currentState = state.idle
var targetState = 0
var storedState = targetState

var velocity = Vector3(0,0,0)
var fallVelocity = Vector3.ZERO
var impulseVelocity = Vector3.ZERO
var rawMoveInput = Vector2.ZERO
var floorNorm = Vector3(0,1,0)
var snap = Vector3(0,-1,0)
var grounded = true
var jumpFrames = 0.0
var doubleJumpFrames = 0
var coyoteCount = 0.0
var doubleJumpCounter = doubleJump
var dashCounter = 1
var dashPowerCounter = 0.0
var dashPowerLimit = 1.0
var wallgrabCounter = 1
var wallGraceFrames = 36
var wallGrabPosition = Vector3.ZERO
var wallGraceFrameCounter = 0
var inWaterModifier = 1.0
var targetDirection = null
var emergeBuffer : ProcessTimer


export(NodePath) var ship
export(NodePath) var camPoint
export(NodePath) var cam
export(NodePath) var wallRay

signal strafing
signal shipentered
signal startpredict
signal endpredict
signal cancelcast
signal startfishplay
signal releasefish
signal playeraction
signal cancelinteract
signal menutoggle
signal walking
signal standing
signal reelingin
signal jumped
signal landed
signal plunged
signal ask_for_reeljump
signal onwall
signal damaged
signal fly_start
signal fly_end
signal player_resource_ready
signal savegame_out_at_ready
signal death

signal island_discovered

func _ready():
	emergeBuffer = ProcessTimer.new(emergeFrames)
	if ship:
		ship = get_node(ship)
	cam = get_node(cam)
	camPoint = get_node(camPoint)
	wallRay = get_node(wallRay)
	if !playerResource:
		playerResource = PlayerResource.new()
		playerResource.first_creation()
	emit_signal("player_resource_ready", playerResource)
	if saveGame:
		emit_signal("savegame_out_at_ready", saveGame)
	GlobalSingleton.register_node(camPoint) #register the node to follow
	GlobalSingleton.player = self
	
	
func _process(delta):
	var moveDict = get_input()
	var moveInput = get_parent().transform.affine_inverse().basis * moveDict['moveInput']
	var horvel = velocity * Vector3(1.0, 0.0, 1.0)
	var velocityRat = 1.0 - (horvel.length() / maxVelocity)
	var ts = turnSpeed * (turnSpeed * 0.8 * float(grounded) + turnSpeed * 0.2) * (1.0 + 1.0 * velocityRat)
	if targetDirection:
		transform.basis = transform.interpolate_with(targetDirection, ts * delta).basis

#	---------------STATEMACHINE---------------------
	currentState = targetState
	
	if currentState == state.idle:
		decay_impulse_velocity(delta)
		drag_velocity(delta)
		emit_signal("standing")
		align_to_movement(moveInput)
		add_velocity(delta, moveInput)
		if Input.is_action_just_pressed('dash'):
			if check_if_dash_possible():
				start_loading_dash()
		if Input.is_action_just_pressed("action"):
			emit_signal("playeraction")
		if Input.is_action_just_pressed("toggle_inventory"):
			emit_signal("menutoggle")
		if Input.is_action_just_pressed("recall"):
			if ship:
				global_transform.origin = ship.get_node("RecallPoint").global_transform.origin
		if moveInput.length() > 0:
			targetState = state.topspeed
		if moveDict['jumpCommandStart']:
			fill_jump_buffer()
		if moveDict['alignCommandStart']:
			targetState = state.strafing
		if !grounded:
			targetState = state.inair
		if jumpFrames > 0:
			start_jump()
			
	if currentState == state.topspeed:
		drag_velocity(delta)
		decay_impulse_velocity(delta)
		emit_signal("walking")
		align_to_movement(moveInput)
		add_velocity(delta, moveInput)
		if Input.is_action_just_pressed('dash'):
			if check_if_dash_possible():
				start_loading_dash()
		if Input.is_action_just_pressed("action"):
			emit_signal("playeraction")
		if moveInput.length() == 0:
			targetState = state.idle
		if moveDict['jumpCommandStart']:
			fill_jump_buffer()
		if moveDict['alignCommandStart']:
			targetState = state.strafing
		if !grounded:
			targetState = state.inair
		if jumpFrames > 0:
			start_jump()
			
	if currentState == state.strafing:
		drag_velocity(delta)
		decay_impulse_velocity(delta)
		emit_signal("strafing")
		align_to_camera(cam)
		strafe(delta, moveInput)
		if Input.is_action_just_pressed("action"):
			emit_signal("playeraction")
		if moveDict['alignCommandRelease']:
			targetState = state.idle
		if GlobalInventory.equipDict["rod"] != null or GlobalSingleton.debug:
			if moveDict['castCommandStart']:
				start_predict()
				velocity.x = 0
				velocity.y = 0	
		if !grounded:
			targetState = state.inair
			emit_signal("cancelcast")
		if Input.is_action_pressed("jump"):
			emit_signal("ask_for_reeljump")
		

	
	if currentState == state.inair:
		if jumpFrames > 0: jumpFrames-=delta
		if doubleJumpFrames > 0 : doubleJumpFrames -= 1
		decay_impulse_velocity_inair(delta)
		if coyoteCount > 0.0: coyoteCount -= delta

		fall(delta)

		align_to_movement(moveInput)
		air_move(delta, moveInput)
		if Input.is_action_just_pressed('dash'):
			if check_if_dash_possible():
				start_loading_dash()
		if moveDict['jumpCommandStart']:
			if coyoteCount > 0.0:
				jump()
			elif doubleJumpCounter > 0:
				fill_doublejump_buffer()
			else:
				fill_jump_buffer()
		if moveDict['jumpHold']:
			if velocity.y > 0:
				velocity.y += fallSpeed * delta;
		if grounded:
			if velocity.y <= 0.5:
				land()
		if check_for_wall(moveInput):
			land_on_wall()
		if doubleJumpFrames > 0:
			inair_jump()
			doubleJumpFrames = 0
			
			
	if currentState == state.onwall:
		var savedY = global_transform.origin.y

		emit_signal("onwall", wallGrabPosition)
		decay_impulse_velocity(delta)
		fall_wall(delta)

		velocity.x = 0.0
		velocity.z = 0.0
		if moveDict['jumpCommandStart']:
			targetState = state.walljumping
		if grounded:
			if velocity.y <= 0.5:
				land()
		if !check_for_wall(moveInput):
			wallGraceFrameCounter += 1
			if wallGraceFrameCounter == wallGraceFrames:
				targetState = state.inair
				wallGraceFrameCounter = 0
	
	if currentState == state.jumping:
		decay_impulse_velocity_inair(delta)
		if grounded:
#			velocity = moveInput * maxVelocity
			align_to_movement(moveInput)
			snap_to_target_direction()
			emit_signal("jumped")
			jump()
			
		if !grounded:
			targetState = state.inair
	
	if currentState == state.walljumping:
		decay_impulse_velocity_inair(delta)
		emit_signal("jumped")
		wall_jump()
		var vely = velocity.y
		var colnorm = wallRay.get_collision_normal()
		if colnorm.dot(moveInput) < .5:
			colnorm.y = 0.0 ##set y component to zero so you dont jump up very high like a bug
			colnorm = colnorm.normalized()
			velocity = (-velocity.reflect(colnorm) + colnorm + moveInput) * maxVelocity
			velocity.y = vely
			impulseVelocity = colnorm * 4.0
		else:
			velocity = moveInput * maxVelocity
			velocity.y = vely
			impulseVelocity = moveInput * 4.0
	
#		if !is_zero_approx(impulseVelocity.length()):
#			impulseVelocity = -impulseVelocity.reflect(colnorm) * maxVelocity
#		else:
#
			
		transform.basis = transform.looking_at(transform.origin + colnorm, transform.basis.y).basis
		snap_model_to_transform()
		targetDirection = transform
		targetState = state.inair
		coyoteCount = 0.0
	
	if currentState == state.doublejump:
		decay_impulse_velocity_inair(delta)
		emit_signal("jumped")
		inair_jump()
		var vely = velocity.y
		align_to_movement(moveInput)
		snap_to_target_direction()
		velocity.y = vely
		targetState = state.inair
		doubleJumpCounter -= 1
	
	if currentState == state.dashload:
		velocity = Vector3.ZERO
		impulseVelocity = Vector3.ZERO
		dashPowerCounter += 3.5 * delta
		if Input.is_action_just_released("dash") or dashPowerCounter >= dashPowerLimit:
			start_dashing(dashPowerCounter)
	
	if currentState == state.dashing:
		if dashPowerCounter > 0.0:
			var dashDirection  = -global_transform.basis.z
			move_and_slide(dashDirection * 48.0)
			dashPowerCounter -= 8.0 * delta
			$AttackingNode.attack()
		else:
			targetState = state.idle
			if grounded:
				reset_dash_counter()
	
	if currentState == state.inwater:
		drag_velocity(delta)
		decay_impulse_velocity(delta)
		swim_up_down(delta * buoyancy)
		add_velocity(delta, moveInput)
		align_to_movement(moveInput)
		if Input.is_action_pressed("aligncam"):
			swim_up_down(-delta * diveSpeed * 2.0)
		if Input.is_action_pressed("jump"):
			jump()
		
	if currentState == state.underwater:
		drag_velocity(delta)
		swim_up_down(delta * buoyancy * 0.3)
		decay_impulse_velocity(delta)
		add_velocity(delta, moveInput)
		align_to_movement(moveInput)
		if Input.is_action_pressed("aligncam"):
			swim_up_down(-delta * diveSpeed)
		if Input.is_action_pressed("jump"):
			swim_up_down(delta * swimSpeed)
	
	if currentState == state.angling:
		decay_impulse_velocity(delta)
		fall(delta)
		velocity = lerp(velocity, Vector3.ZERO, delta * drag * 0.1)
		align_to_camera(cam)

	
	if currentState == state.attacked:
		decay_impulse_velocity(delta)
		fall(delta)
		velocity = lerp(velocity, Vector3.ZERO, delta * drag * 0.1)
	
	if currentState == state.gaming:
		decay_impulse_velocity(delta)
		velocity = Vector3.ZERO
		
	if currentState == state.reelin:
		decay_impulse_velocity(delta)
		velocity = Vector3.ZERO

	if currentState == state.interacting:
		decay_impulse_velocity(delta)
		velocity = Vector3.ZERO

	if currentState == state.inmenu:
		decay_impulse_velocity(delta)
		velocity = Vector3.ZERO
		if Input.is_action_just_pressed("toggle_inventory"):
			emit_signal("menutoggle")
	
	if currentState == state.investigating:
		decay_impulse_velocity(delta)
		velocity = Vector3.ZERO
	
	velocity = move_and_slide_with_snap(velocity + impulseVelocity + fallVelocity, snap, Vector3.UP, true, 3)
	playerResource.savedTransform = global_transform

func get_input():
	var moveInput = Vector3.ZERO
	var orthox = cam.global_transform.basis.x.normalized()
	var orthoz = cam.global_transform.basis.z.normalized()
	moveInput = orthox * (Input.get_action_strength("moveright") - Input.get_action_strength("moveleft")) + orthoz * (Input.get_action_strength("movedown") - Input.get_action_strength("moveup"))
	rawMoveInput = Vector2((Input.get_action_strength("moveright") - Input.get_action_strength("moveleft")), (Input.get_action_strength("movedown") - Input.get_action_strength("moveup")))
	var moveDict ={
		'moveInput' : moveInput.normalized(),
		'jumpCommandStart' : Input.is_action_just_pressed("jump"),
		'jumpHold' : Input.is_action_pressed("jump"),
		'jumpCommandRelease' : Input.is_action_just_released("jump"),
		'castCommandStart' : Input.is_action_just_pressed("cast"),
		'castCommandRelease' : Input.is_action_just_released("cast"),
		'alignCommandStart' : Input.is_action_pressed("aligncam"),
		'alignCommandRelease' : Input.is_action_just_released("aligncam")
	}
	return moveDict

func decay_impulse_velocity_inair(delta):
	impulseVelocity = lerp(impulseVelocity, Vector3.ZERO, delta * drag * 0.1)
	if impulseVelocity.length() < 1.0:
		impulseVelocity = Vector3.ZERO		

func drag_velocity(delta):
	velocity = velocity.move_toward(Vector3.ZERO, drag * delta) ##DRAG
#	velocity -= velocity * velocity * delta * 20

func decay_impulse_velocity(delta):
	impulseVelocity = lerp(impulseVelocity, Vector3.ZERO, delta * drag)
	if impulseVelocity.length() < 1.0:
		impulseVelocity = Vector3.ZERO		

func fall(delta):
	var fallvel = transform.basis.y * ((grav - $CombiJumpCounter.combiAmount * combiGravMinus) * inWaterModifier) * delta
	velocity -= fallvel
	velocity.y = clamp(velocity.y, -maxFallSpeed, 10000)
	#velocity.y = clamp(velocity.y - ((grav - $CombiJumpCounter.combiAmount * combiGravMinus) * inWaterModifier * delta), -maxFallSpeed, 10000)

func fall_wall(delta):
	velocity.y = clamp(velocity.y - ((grav - $CombiJumpCounter.combiAmount * combiGravMinus * 0.1) * delta), -maxFallSpeed * 0.05, 10000)
#	velocity.x *= 0.8
#	velocity.z *= 0.8

func add_velocity(delta, moveInput):
	var vel = -global_transform.basis.z * moveSpeed * moveInput.length() * delta
	var vely = velocity.y
	velocity += vel * (moveFactor * moveFactor)
	velocity.y = 0.0
	velocity = velocity.limit_length(maxVelocity)
	velocity.y = vely

func air_move(delta, moveInput):
	var vel = -global_transform.basis.z * moveSpeed * moveInput.length() * delta
	velocity += vel * moveFactor * inAirMod
	var vely = velocity.y
	velocity.y = 0.0
	velocity = velocity.limit_length(maxVelocity + 0.5)
	velocity.y = vely

func strafe(delta, moveInput):
#	var localMoveInput = get_parent().transform.affine_inverse().basis * moveInput
#	velocity = localMoveInput * strafeSpeed * delta
#	velocity = velocity.normalized()
	var strafeVel = Vector3.ZERO
	strafeVel += rawMoveInput.x * global_transform.basis.x
	strafeVel += rawMoveInput.y * global_transform.basis.z
	velocity = strafeVel.normalized()

func swim_underwater(delta, moveInput):
	var vel = -cam.global_transform.basis.z * swimSpeed * moveInput.length() * delta
	var vely = velocity.y
	velocity += vel * (moveFactor * moveFactor)
	velocity.y = 0.0
	velocity = velocity.limit_length(maxVelocity)
	velocity.y = vely
	
func swim_up_down(delta):
	var fallvel = transform.basis.y * delta  
	velocity += fallvel
	velocity.y = clamp(velocity.y, -maxFallSpeed, 10000)

func fill_jump_buffer():
	jumpFrames = jumpBuffer

func fill_doublejump_buffer():
	doubleJumpFrames = doubleJumpBuffer

func reset_doublejump_counter():
	doubleJumpCounter = 1

func start_jump():
	targetState = state.jumping
	reset_doublejump_counter()
	

func jump():
	snap = Vector3.ZERO
	velocity.y = 0
	var veladd = (velocity.length() / maxVelocity * jumpVelocityAdd)
	var combiadd = ($CombiJumpCounter.combiAmount * combiJumpAdd)
	velocity.y += jumpSpeed + veladd + combiadd;
	jumpFrames = 0
	targetState = state.inair
	coyoteCount = 0.0
	print('jump')

func inair_jump():
	velocity.y = 0
	var veladd = (velocity.length() / maxVelocity * jumpVelocityAdd)
	var combiadd = ($CombiJumpCounter.combiAmount * combiJumpAdd)
	velocity.y += jumpSpeed + veladd + combiadd;
	doubleJumpFrames = 0;
	doubleJumpCounter -= 1
	print('jump')

func wall_jump():
	velocity.y = 0
	velocity.y += jumpSpeed;
	jumpFrames = 0;
	print('jump')

func rod_jump(point):
	var is_possible = true
#	if saveGame:
#		is_possible = saveGame.upgradeCollectionResource.get_upgrade("rodtricks").check_if_equip_full("Rod jump")
	if is_possible:
		snap = Vector3.ZERO
		reset_doublejump_counter()
		targetState = state.inair
		var targetPoint = point
		var dir = targetPoint - global_transform.origin
		impulseVelocity += (dir + (-global_transform.basis.z * dir.length())) * 0.6
		impulseVelocity.y = 0.0
		velocity.y += dir.y + jumpSpeed * 1.5

func land():
#	global_transform.origin = get_ground_point()
	playerResource.savedTransform = global_transform
	playerResource.savedTransform.origin += Vector3(0,2,0)
	coyoteCount = coyoteSec
	targetState = state.idle
	if saveGame:
		if saveGame.upgradeCollectionResource.get_upgrade("dash").check_if_equip_full("Double dash"):
			dashCounter = 2
		else:
			dashCounter = 1
	else:
		dashCounter = 1
	wallgrabCounter = 1
	doubleJumpFrames = 0
	emit_signal("landed")
	print('landed')

func get_ground_point():
	var point = $GroundRay.get_collision_point()
	return point

func land_on_wall():
	targetState = state.onwall
	wallGrabPosition = wallRay.get_collision_point()

	wallgrabCounter = 1
	print('wallgrab')

func reset_dash_counter():
	if saveGame:
		if saveGame.upgradeCollectionResource.get_upgrade("dash").check_if_equip_full("Double dash"):
			dashCounter = 2
		else:
			dashCounter = 1
	else:
		dashCounter = 1

func start_loading_dash():
	dashPowerCounter = dashPowerLimit * 0.25
	targetState = state.dashload

func start_dashing(power):
	targetState = state.dashing
	dashCounter -= 1

func start_predict():
#	targetState = state.angling
	emit_signal("startpredict")

func align_to_camera(_cam):
	var localCamBasis = get_parent().transform.affine_inverse().basis * _cam.global_transform.basis #convert cam basis to local basis
	var localTrans = transform
	targetDirection = localTrans.looking_at(localTrans.origin - localCamBasis.z, localTrans.basis.y) 
	
func align_to_movement(moveInput):
	if moveInput.length() > 0.01:
		var localPos = transform.origin + moveInput #get global position to aim for
#		var localMI = get_parent().transform.affine_inverse() * localPos #convert global position to local position ((DOESNT WORK WITH MULTIPLE PARENTS))
		var localTrans = transform
		targetDirection = localTrans.looking_at(localPos, localTrans.basis.y)  
	else:
		targetDirection = transform 

func align_to_movement_global(moveInput):
	if moveInput.length() > 0.01:
		var globalPos = global_transform.origin + moveInput #get global position to aim for
		var localTrans = global_transform
		targetDirection = localTrans.looking_at(globalPos, localTrans.basis.y)  
	else:
		targetDirection = global_transform 

func snap_to_target_direction():
	transform.basis = targetDirection.basis

func snap_model_to_transform():
	pass

func enter_ship():
	return $PlayerFlockManager.empty_flock_to_ship()

func check_if_dash_possible():
	if saveGame:
		if dashCounter > 0:
			return true
		else:
			return false
	else:
		return true

func check_for_wall(moveInput):
	var colnorm = wallRay.get_collision_normal()
	var dot = moveInput.dot(colnorm)
	var moveInputLength = moveInput.length()
	return wallRay.is_colliding() && wallgrabCounter > 0 && !is_zero_approx(moveInputLength) && dot < -0.7

func attacked(attackingNode):
	if currentState != state.attacked && !immuneToAttackStates.has(currentState):
		storedState = currentState
		emit_signal("damaged", self)
		targetState = state.attacked
		var dir = global_transform.origin - attackingNode.global_transform.origin
		impulseVelocity += dir * 4.0
		impulseVelocity.y += 2.0

func recovered():
	if currentState == state.attacked:
		targetState = state.idle

func fly_start():
	targetState = state.gaming
	emit_signal("fly_start")
	
func fly_end():
	targetState = state.idle
	emit_signal("fly_end")
	
func die():
	emit_signal("death")

func _on_RaycastPivot_interacted():
	targetState = state.interacting

func _on_RaycastPivot_interaction_cancelled():
	targetState = state.idle

func _on_CastManager_fish_hooked(_fish):
	currentState = state.reelin

func _on_FloorCheckers_on_floor():
	grounded = true;
	snap = Vector3(0,-1,0)


func _on_FloorCheckers_not_on_floor():
	grounded = false
	snap = Vector3.ZERO

func _on_PlayerAttackbleNode_playerattacked(attackingNode):
	attacked(attackingNode)

func _on_PlayerAttackbleNode_playerrecovered():
	if currentState == state.attacked:
		targetState = state.idle

func _on_CatchNode_fish_netted(_fish):
	targetState = state.gaming

func set_player_resource(_res):
	playerResource = _res
	global_transform = playerResource.savedTransform

func _on_World_savegame_out(savegame):
	set_player_resource(savegame.playerResource)

func enter_island(islandResource):
	emit_signal("island_discovered", islandResource)

func _on_ParentFloorChecker_parent_to(targetParent):
	pass


func _on_ParentFloorChecker_unparented(direction):
	pass


func _on_PlayerMenu_menu_opened():
	targetState = state.inmenu


func _on_PlayerMenu_menu_closed():
	targetState = state.idle


func _on_InvestigatingNode_start_investigating():
	targetState = state.investigating


func _on_InvestigatingNode_stop_investigating():
	targetState = state.idle


func _on_PlayerWaterNode_emerged():
	targetState = state.inair
	pass


func _on_PlayerWaterNode_submerged():
	reset_doublejump_counter()
	targetState = state.inwater


func _on_PlayerWaterNode_underwater():
	targetState = state.underwater


func _on_CastManager_reeljump(jumpPoint):
	if jumpPoint:
		rod_jump(jumpPoint)
