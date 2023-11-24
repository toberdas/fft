extends Spatial

var defaultWorldVibe = preload("res://assets/resources/island/DEFAULTVibe.tres")
const updateSeconds = 1.0

export(Curve) var falloffCurve
var us = 0.0

var resource

func _on_IslandNode_start_initialize(save):
	resource = save.islandResource.mood

func _on_VibeManager_update_mood(distrat):
	if resource:
		if distrat:
			distrat = falloffCurve.interpolate(distrat)
	#
			var primCol = defaultWorldVibe.primaryColor.linear_interpolate(resource.primaryColor, distrat)
			var secCol = defaultWorldVibe.secondaryColor.linear_interpolate(resource.secondaryColor, distrat)
			defaultWorldVibe.add_color(primCol)
			defaultWorldVibe.add_color(secCol)
