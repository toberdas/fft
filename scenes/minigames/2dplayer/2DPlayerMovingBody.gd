extends KinematicBody2D

const GRAVITY = 500
const JUMP_SPEED = -200
const MOVE_SPEED = 150
const RUN_SPEED = 250
const DASH_SPEED = 500
const DASH_TIME = 0.2
const WALL_JUMP_SPEED = -200
const WALL_JUMP_TIME = 0.2
const acceleration = .1

enum State {
	STAND,
	RUN,
	JUMP,
	FALL,
	DASH,
	WALL_SLIDE,
	WALL_JUMP
}

var velocity = Vector2.ZERO
var state = State.STAND
var dash_timer = 0
var wall_jump_timer = 0
var wall_normal = Vector2.ZERO

func _physics_process(delta):
	# apply gravity
	velocity.y += GRAVITY * delta

	# handle state transitions
	match state:
		State.STAND:
			if Input.is_action_pressed("jump"):
				velocity.y = JUMP_SPEED
				state = State.JUMP
			elif Input.is_action_pressed("dash"):
				dash_timer = DASH_TIME
				state = State.DASH
			elif Input.get_action_strength("ui_left") != 0 or Input.get_action_strength("ui_right") != 0:
				state = State.RUN
			elif is_on_floor():
				velocity.x = 0
				state = State.STAND
			else:
				state = State.FALL

		State.RUN:
			if Input.is_action_pressed("jump"):
				velocity.y = JUMP_SPEED
				state = State.JUMP
			elif Input.is_action_pressed("dash"):
				dash_timer = DASH_TIME
				state = State.DASH
			elif Input.get_action_strength("ui_left") == 0 and Input.get_action_strength("ui_right") == 0:
				state = State.STAND
			elif not is_on_floor():
				state = State.FALL

		State.JUMP:
			if velocity.y >= 0:
				state = State.FALL
			elif Input.is_action_pressed("dash"):
				dash_timer = DASH_TIME
				state = State.DASH

		State.FALL:
			if is_on_floor():
				velocity.y = 0
				state = State.STAND
			elif Input.is_action_pressed("dash"):
				dash_timer = DASH_TIME
				state = State.DASH
			elif is_on_wall():
				wall_normal = $RayCast2D.get_collision_normal()
				if Input.is_action_pressed("jump"):
					velocity.y = WALL_JUMP_SPEED
					wall_jump_timer = WALL_JUMP_TIME
					state = State.WALL_JUMP
				else:
					state = State.WALL_SLIDE
			elif not is_on_floor():
				state = State.FALL

		State.DASH:
			if dash_timer <= 0 or not is_on_floor():
				state = State.FALL
			else:
				dash_timer -= delta

		State.WALL_SLIDE:
			if not is_on_wall():
				state = State.FALL
			elif Input.is_action_pressed("jump"):
				velocity.y = JUMP_SPEED
				velocity.x = -wall_normal.x * MOVE_SPEED
				state = State.JUMP

		State.WALL_JUMP:
			if wall_jump_timer <= 0:
				state = State.FALL
			else:
				wall_jump_timer -= delta

	# handle input and movement
	var input_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if state == State.RUN:
		velocity.x = input_x * RUN_SPEED
	elif state == State.DASH:
		velocity.x = input_x * DASH_SPEED
	elif state == State.JUMP or state == State.FALL:
		velocity.x = input_x * RUN_SPEED
	elif state == State.WALL_SLIDE or state == State.WALL_JUMP:
		velocity.y = clamp(velocity.y, -MOVE_SPEED, GRAVITY)

	velocity = move_and_slide(velocity, Vector2.UP)

