extends Spatial

signal fish_caught
signal wall_bashed

var savegame : SaveGame

func _on_AttackingNode_body_attacked(body):
	if body.is_in_group("Fish") && check_if_can_catch_fish():
		body.netted(self)
		emit_signal("fish_caught", body)
	if body.is_in_group("Walls") && check_if_can_destroy_walls():
		body.queue_free()
		emit_signal("wall_bashed", body)


func _on_Player_savegame_out_at_ready(_savegame):
	savegame = _savegame

func check_if_can_catch_fish():
	if savegame:
		return savegame.playerResource.equipResource.check_slot_full('Net') && savegame.upgradeCollectionResource.get_upgrade("dash").check_if_equip_full("Overwhelming speed")

func check_if_can_destroy_walls():
	if savegame:
		return savegame.upgradeCollectionResource.get_upgrade("dash").check_if_equip_full("Shattering speed")
