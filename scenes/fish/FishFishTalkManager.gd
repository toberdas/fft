extends FishTalkManager


func _on_Fish_start_play():
	var fishTalk = make_fishtalk_scene_from_data(owner.fishData)
	add_child(fishTalk) #add the fishtalk scene ofcourse

