class_name MoveTowardsFloat
extends MoveTowards



func measure_difference():
	transitionIncrement = abs(objectA - objectB) / steps

func transition_step():
	objectA = move_toward(objectA, objectB, transitionIncrement)
	return objectA
