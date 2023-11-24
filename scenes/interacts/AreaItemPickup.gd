extends Spatial



func _on_InteractScene_scene_closed():
	var items = $FallenItemArea.get_overlapping_bodies()
	for item in items:
		item.owner.pick_up()
