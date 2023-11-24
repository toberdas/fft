extends FlockManager

func empty_flock_to_ship():
	var _fd = fishDict
	fishDict = {}
	fishCaptureResource.clear_list()
	return _fd

func _on_CatchNode_caught(fish):
	add_fish_to_fill_flock(fish)

func _on_Player_player_resource_ready(playerResource):
	fishCaptureResource = playerResource.fishCaptureResource
	make_fish_from_capture_resource(fishCaptureResource)

func _on_Player_damaged(_player):
	free_all_fish()
