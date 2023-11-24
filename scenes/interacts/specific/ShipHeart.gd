extends Spatial

var interactScene = null

onready var interactable_component = $InteractableComponent

signal ship_resource_out
signal upgrade_collection_out
signal save_game_out

func _on_Ship_ship_loaded(shipResource : ShipResource):
	emit_signal("ship_resource_out", shipResource)

func _on_Menu_menu_closed():
	interactable_component.interactScene.mouse.switch(true)
		


func _on_FishMenu_emit_key(keyInstance):
	$KeyAddNode.add_child(keyInstance)


func _on_FishMenu_menu_opened():
	interactable_component.interactScene.mouse.switch(false)


func _on_Ship_upgrade_collection_loaded(upgradeCollection):
	emit_signal("upgrade_collection_out", upgradeCollection)


func _on_Ship_save_game_out(saveGame):
	emit_signal("save_game_out", saveGame)
