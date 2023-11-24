extends FlockManager


func _on_Ship_ship_loaded(shipResource):
	if shipResource:
		fishCaptureResource = shipResource.fishCaptureResource
		make_fish_from_capture_resource(fishCaptureResource)


func _on_ParentArea_child_parented(player:Player):
	var flockDict = player.enter_ship()
	if !flockDict.empty():
		fillFlock = flockDict
