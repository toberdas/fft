extends Node
class_name RandomWalk


func step():
	pass

func walk_tracked():
	pass

func walk_untracked(stepAmount):
	var stepList = [Vector2.ZERO]
	for stepIndex in range(stepAmount):
		var prevLocation = stepList[stepIndex]
		var newLocation = prevLocation + Vector2(int(rand_range(-1.0,1.0)),int(rand_range(-1.0,1.0)))
		stepList.append(newLocation)
	return stepList

func walk_in_bounds(stepAmount, xbound, ybound):
	var stepList = [Vector2.ZERO]
	for stepIndex in range(stepAmount):
		var prevLocation = stepList[stepIndex]
		var xsign =1
		var ysign =1
		if randf() > .5:
			xsign = -1
		if randf() > .5:
			ysign = -1
		var newLocation = prevLocation + Vector2((randi() % 2) * xsign, (randi() % 2) * ysign)
		newLocation.x = clamp(newLocation.x, -xbound, xbound)
		newLocation.y = clamp(newLocation.y, -ybound, ybound)
		stepList.append(newLocation)
	return stepList
