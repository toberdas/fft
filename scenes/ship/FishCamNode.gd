extends Spatial



func _on_ItemList_emit_fish_capture_item(save : FishSave):
	if save.fishData:
		var data = save.fishData
		if data.scene:
			$RotatingCamOrigin.mission(data.scene)
