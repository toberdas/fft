extends Control
class_name UpgradeScene


const upgradeScene = preload("res://scenes/ship/UpgradeScene.tscn")
export(Resource) var upgradeCollection

onready var tab_container = $MarginContainer/VBoxContainer/TabContainer


onready var label = $MarginContainer/VBoxContainer/Label

var upgradeSceneList = []

func added_to_menu():
	open_and_add_upgrades()

func _exit_tree():
	close_upgrades()

func close_upgrades():
	for upgrade in upgradeSceneList:
		upgrade.close()
	upgradeSceneList = []

func open_and_add_upgrades():
	if !upgradeCollection:
		return
	label.text = upgradeCollection.label
	for upgrade in upgradeCollection.upgradeList:
		var newUpgradeInstance = upgradeScene.instance()
		newUpgradeInstance.upgradeResource = upgrade
		newUpgradeInstance.name = upgrade.label
		tab_container.add_child(newUpgradeInstance)
		newUpgradeInstance.open_upgrade()
		upgradeSceneList.append(newUpgradeInstance)
	pass

func _unhandled_input(event):
	if Input.is_action_just_pressed('rb'):
		tab_container.current_tab = clamp(tab_container.current_tab + 1,0,tab_container.get_tab_count() - 1)
	if Input.is_action_just_pressed('lb'):
		tab_container.current_tab = clamp(tab_container.current_tab - 1,0,tab_container.get_tab_count())
