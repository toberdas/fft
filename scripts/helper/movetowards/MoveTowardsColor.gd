class_name MoveTowardsColor
extends MoveTowards



func measure_difference():
	var diff = ColorUtil.get_biggest_difference(objectA, objectB)
	transitionIncrement = diff / steps

func transition_step():
	objectA = ColorUtil.move_toward_color(objectA, objectB, transitionIncrement)
	return objectA
