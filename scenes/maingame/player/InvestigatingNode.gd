extends StateDependentPlayerEventNode

var investigationInstance = null

signal start_investigating
signal stop_investigating

const investigationScene = preload("res://scenes/maingame/player/Investigation.tscn")

#func check_conditions():
#	if player.saveGame:
#		return Input.is_action_just_pressed('r3') && player.saveGame.upgradeCollectionResource.get_upgrade("inspector").check_if_equip_full("Learn to inspect")
#	else:
#		return Input.is_action_just_pressed('r3')

func check_conditions():
	return Input.is_action_just_pressed('r3')
		
func check_deactivate_conditions():
	if Input.is_action_just_pressed('r3') && player.currentState == Player.state.investigating:
		return true
	if player.currentState != Player.state.investigating && active:
		return true

func start_event():
	investigationInstance = investigationScene.instance()
	add_child(investigationInstance)
	emit_signal("start_investigating")

func stop_event():
	investigationInstance.queue_free()
	emit_signal("stop_investigating")
