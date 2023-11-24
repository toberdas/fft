extends Spatial


const updateSeconds = 1.0
var us = 0.0

var resource
var distance = 0

var primCol = Color()
var secCol = Color()



func _on_IslandNode_start_initialize(_resource):
	distance = _resource.loadDistance
	resource = _resource.islandVibeResource
	

func _process(delta):
	if resource:
		update_color()

func update_color():
	var distToPlayer = GlobalSingleton.player.global_transform.origin - global_transform.origin
	if distToPlayer.length() < distance:
		var rat = (distToPlayer.length() / distance)
		if resource.colourFalloffCurve:
			rat = resource.colourFalloffCurve.interpolate(rat)
		else:
			rat = 1 - rat
		primCol = lerp(primCol, resource.primaryColor, .1)
		secCol = lerp(secCol, resource.secondaryColor, .1)

		var defPrimCol = GameData.defaultPrimCol
		var defSecCol = GameData.defaultSecCol

		GlobalSingleton.cam.environment.background_color = defPrimCol.linear_interpolate(primCol, rat)
		GlobalSingleton.cam.environment.ambient_light_color = defSecCol.linear_interpolate(secCol, rat)
		GlobalSingleton.cam.environment.fog_color = defPrimCol.linear_interpolate(primCol, rat)
