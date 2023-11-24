extends Spatial

var resource
var trackPlayer = null
var playerDistance setget ,getPlayerDistance
var distanceRatio setget , getDistanceRatio

signal player_distance_out

func getPlayerDistance():
	if is_instance_valid(GlobalSingleton.player):	
		var d = (GlobalSingleton.player.global_transform.origin - global_transform.origin).length()
		return (GlobalSingleton.player.global_transform.origin - global_transform.origin).length()
	else:
		return null

func getDistanceRatio():
	var dist = getPlayerDistance()
	if GlobalSingleton.player:
		if resource && dist:
			return (dist / GameplayConstants.islandLoadDistance)
		else:
			return null
	else:
		return 0.0

func _on_IslandNode_start_initialize(save):
	resource = save.islandResource

func _on_TrackTimer_timeout():
	if GlobalSingleton.player:
		var dist = getPlayerDistance()
		if dist:
			emit_signal("player_distance_out", dist)
