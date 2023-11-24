extends MarginContainer

var fishData


func _enter_tree():
	if fishData:
		$FishFace.run(fishData)


func _on_ItemList_emit_fish_capture_item(save : FishSave):
	if save.fishData:
		fishData = save.fishData
		$FishFace.run(fishData)

