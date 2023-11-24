extends ColorRect
class_name Fragment

var activated = false
var currentFishSave

func activate(save : FishSave):
	currentFishSave = save
	var returnDict = {}
	play_activation_animation()
	set_fragment_color(currentFishSave.fishData)
	activated = true
	return true

func play_activation_animation():
	$AnimationPlayer.play("activate")

func set_fragment_color(fishData:FishData):
	modulate = fishData.color

func reset_fragment_color():
	modulate = Color(1,1,1,1)

func check_if_activated():
	return activated

func compare_fish_item(save : FishSave):
	var rv = false
	if currentFishSave:
		if save.fishData == currentFishSave.fishData:
			rv = true
	return rv

func set_acquiered():
	currentFishSave.fragmentAcquiered = true

func clear():
	activated = false
	currentFishSave = null
	reset_fragment_color()

func get_fish_color():
	return currentFishSave.fishData.color
	
