extends Control

const equipScene = preload("res://scenes/inventory/Equip.tscn")

onready var v_box_container = $MarginContainer/VBoxContainer
onready var upgrade_tooltip = $MarginContainer/VBoxContainer/HBoxContainer/UpgradeTooltip


var upgradeResource : UpgradeResource

var equipSceneInstance

func open_upgrade():
	if !upgradeResource:
		return
	upgrade_tooltip.text = upgradeResource.tooltip
	equipSceneInstance = equipScene.instance()
	equipSceneInstance.equipResource = upgradeResource.equipResource
	v_box_container.add_child(equipSceneInstance)
	equipSceneInstance.open_and_add_item_nodes()
	equipSceneInstance.set_all_equipslots_tooltip_target($MarginContainer/VBoxContainer/HBoxContainer/EquipTooltip)

func close():
	queue_free()
