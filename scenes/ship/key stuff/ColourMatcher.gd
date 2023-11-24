extends Node


export(Array, Color) var possibleColors
export(Array, Resource) var matchingObjects

func match_color(color:Color):
	var score = 3.0
	var matchingColor = Color()
	for tryColor in possibleColors:
		var newScore = 0.0
		newScore += abs(tryColor.r - color.r)
		newScore += abs(tryColor.g - color.g)
		newScore += abs(tryColor.b - color.b)
		if newScore < score:
			matchingColor = tryColor
			score = newScore
	return matchingColor

func match_object(color:Color):
	var matchingColor = match_color(color)
	var index = possibleColors.find(matchingColor)
	return matchingObjects[index]
