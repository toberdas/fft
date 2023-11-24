extends NodeTracker

signal emit_player_global_transform


func _on_Timer_timeout():
	var playerGlobalTransform = get_node_global_transform()
	if playerGlobalTransform:
		emit_signal("emit_player_global_transform", playerGlobalTransform)


func _on_World_player_out(player):
	set_node_to_track(player)
	emit_signal("emit_player_global_transform", player.global_transform)
