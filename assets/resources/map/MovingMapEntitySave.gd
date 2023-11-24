extends MapEntitySave
class_name MovingMapEntitySave

export(Vector2) var targetPoint = Vector2.ZERO
export(int) var timeAtTarget
export(int) var maxTimeAtTarget = 12000
export(float) var moveSpeed = 0.00001
export(bool) var atTarget
export(bool) var moving = true setget set_moving

func update(map):
	if moving:
		if point && targetPoint:
			point = point.move_toward(targetPoint, moveSpeed)
			if point == targetPoint:
				if timeAtTarget == 0: target_reached()
				timeAtTarget += 1
				if timeAtTarget >= maxTimeAtTarget:
					target_left()
					timeAtTarget = 0
					targetPoint = get_new_target_point(map)

func target_reached():
	atTarget = true

func target_left():
	atTarget = false

func get_new_target_point(_map):
	return HelperScripts.random_vec2()

func set_moving(val):
	moving = val
