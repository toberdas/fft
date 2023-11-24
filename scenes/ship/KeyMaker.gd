extends Control

onready var fragment_container = $VBoxContainer/FragmentContainer
onready var fragment_add_button = $VBoxContainer/HBoxContainer/FragmentAddButton

var selectedFishData : FishData
var selectedFishSave : FishSave = null


const heartScene = preload("res://scenes/fish/FishMemoryScene.tscn")
var heartInstance = null

signal fragment_add_start
signal fragment_added
signal key_created

func start_adding_fragment():
	if !check_if_fragment_ok():
		return
	fragment_add_button.release_focus()
	heartInstance = heartScene.instance()
	heartInstance.fishData = selectedFishData
	
	$FadeNode.add_child(heartInstance)
	heartInstance.connect("heart_warmed", self, "fragment_added")
	heartInstance.connect("switch_screen_out", self, "fragment_add_stopped")

func check_if_fragment_ok():
	var rv = false
	if selectedFishSave:
		if !fragment_container.check_if_fragment_present(selectedFishSave):
			if !fragment_container.check_if_fragments_full():
				if !selectedFishSave.fragmentAcquiered:
					rv = true
	return rv

func fragment_added():
	emit_signal("fragment_added", selectedFishSave)
	close_heart_scene()

func fragment_add_stopped(_msg):
	close_heart_scene()

func close_heart_scene():
	if heartInstance:
		heartInstance.queue_free()
		heartInstance = null
		fragment_add_button.grab_focus()

func start_forging():
	if !fragment_container.check_if_fragments_full():
		return
	var color = fragment_container.get_combined_color()
	var keyResource = $ColourMatcher.match_object(color)
	var new3DItem = ItemData.create_3d_item_from_resource(keyResource)
	fragment_container.key_forged()
	emit_signal("key_created", new3DItem)

func _on_ItemList_emit_fish_capture_item(save : FishSave):
	if save.fishData:
		selectedFishData = save.fishData
	selectedFishSave = save

func _on_FragmentAddButton_pressed():
	start_adding_fragment()

func _on_ForgeKeyButton_pressed():
	start_forging()
