extends ItemList

signal emit_fish_capture_item

func _on_ShipFishList_fishCaptureOut(fishCaptureResource):
	if fishCaptureResource:
		clear()
		for key in fishCaptureResource.captureDict.keys():
			var save : FishSave = fishCaptureResource.captureDict[key]
			var data
			if save.fishData:
				data = save.fishData
			else:
				data = save.generate_fish_data()
			add_item(data.brain.character.fishName, null, true)
			var count = get_item_count()
			if count > 0:
				set_item_metadata(count - 1, save)
		
		if get_item_count() > 0:
			select(0)
			activate_fish(0)

func _on_ItemList_item_activated(index):
	activate_fish(index)
	
func activate_fish(index):
	if index >= 0:
		if get_item_count() > 0:
			var save : FishSave = get_item_metadata(index)
			if save:
				emit_signal("emit_fish_capture_item", save)
