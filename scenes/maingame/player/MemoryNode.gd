extends FishTalkManager

var fishtalkScene = null

func _enter_tree():
	fishtalkScene = start_fishtalk_from_equip_data()
	if fishtalkScene:
		$CenterContainer/VBoxContainer/Button.disabled = false
	else:
		$CenterContainer/VBoxContainer/Button.disabled = true

func _exit_tree():
	if fishtalkScene:
		if is_instance_valid(fishtalkScene):
#			remove_child(fishtalkScene)
			fishtalkScene.queue_free()
	fishtalkScene = null

func start_fishtalk_from_equip_data():
	var ret = null
	var equipedMemory = GlobalInventory.equipDict["memory"]
	if equipedMemory:
		var fishData = equipedMemory.extendedResource
		ret = make_fishtalk_scene_from_data(fishData) 
	return ret

func _on_Button_pressed():
	add_child(fishtalkScene)
