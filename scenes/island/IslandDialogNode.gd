extends Spatial

var resource = preload("res://assets/resources/island/dialogtest/TESTDIALOGCONTAINER.tres")

enum triggerType{on_island_approach, on_fish_caught, on_last_fish}  #corresponds to dialog resource triggertypes

func player_entered_island(): #connected to signal from islandNode
	emit_trigger(triggerType.on_island_approach)

func fish_caught(fishcount): #connected to signal from islandNode
	if fishcount > 1:
		emit_trigger(triggerType.on_fish_caught)
	else:
		emit_trigger(triggerType.on_last_fish)

func _on_IslandNode_start_initialize(islandResource : IslandResource, _player):
	if islandResource:
		if islandResource.islandDialog:
			resource = islandResource.islandDialog.duplicate()

func emit_trigger(type):
	for dialog in resource.dialogArray:
		if !dialog.played:
			if dialog.trigger == type:
				$DialogManager.run_dialog_event(dialog)
				dialog.played = true
				return
#	for dialog in resource.dialogArray: #another for if every dialog is already played
#		if dialog.trigger == type:
#			$DialogManager.run_dialog_event(dialog)
#			dialog.played = true
#			return


func _on_IslandFishNode_fish_caught(fishcount):
	fish_caught(fishcount)


func _on_WholeIslandBox_player_entered(_player):
	player_entered_island()
