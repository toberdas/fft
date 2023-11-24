extends EndlessSea

func _on_World_savegame_out(savegame:SaveGame):
	var loadPos = Vector3.ZERO
	if savegame.playerResource:
		loadPos = savegame.playerResource.savedTransform.origin
	scale_and_check_position(loadPos, true)

func _on_WorldPlayerTracker_emit_player_global_transform(playerGlobalTransform):
	scale_and_check_position(playerGlobalTransform.origin, true)
