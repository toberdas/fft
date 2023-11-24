extends Node

var active = false

var radius = 0.1
var worldMap : Resource
var mySaveGame : SaveGame
signal points_in_radius

func check_map(worldpos):
#	var lp = worldpos.posmodv(GameplayConstants.worldSize) / GameplayConstants.worldSize
	var lp = worldpos / GameplayConstants.worldSize
	var loadPoints = []

	for mapEntity in worldMap.get_all_entities():
		var point = mapEntity.point
		var loadDistance = mapEntity.loadDistance
		var rl = ((point - lp) * GameplayConstants.worldSize).length()
		if rl < loadDistance:
#			var mod = (worldpos / GameplayConstants.worldSize).floor()
			var mod = Vector2.ZERO
			loadPoints.append({
				"save" : mapEntity,
				"realPoint" : (point + mod) * GameplayConstants.worldSize
			})
	emit_signal("points_in_radius", loadPoints)

func check_on_start():
	pass

func _on_World_savegame_out(savegame:SaveGame):
	worldMap = savegame.worldMap
	mySaveGame = savegame
	var loadPos = Vector3.ZERO
	if savegame.playerResource:
		loadPos = savegame.playerResource.savedTransform.origin
	check_map(Vector2(loadPos.x, loadPos.z))
	active = true
	

func _on_World_map_out(map):
	worldMap = map

func _on_WorldPlayerTracker_emit_player_global_transform(playerGlobalTransform):
	check_map(Vector2(playerGlobalTransform.origin.x, playerGlobalTransform.origin.z))

func discover_island(point):
	if mySaveGame.playerResource:
		if !mySaveGame.playerResource.discoverIslandPointList.has(point):
			mySaveGame.playerResource.discoverIslandPointList.append(point)
