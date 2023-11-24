extends CellAdditionScene

var matchingKey = preload("res://assets/resources/items/specificItems/KEYS/BlueKey.tres") setget set_matching_key
export(Resource) var treasureResource

onready var animation_player = $chest/lid/AnimationPlayer
onready var key_hole_pickable = $chest/lid/KeyHolePickable
onready var menu_node = $MenuNode
onready var interactable_component = $chest/InteractableComponent

onready var chest_animation_player = $ChestAnimationPlayer


var itemScene = preload("res://scenes/item/3DItem.tscn")
signal treasure_found

func load_addition():
	set_treasure_resource(cellAddition)

func load_anything():
	matchingKey = treasureResource.key
	$chest/cont.get_active_material(0).albedo_color = matchingKey.iconModulate
	$chest/lid.get_active_material(0).albedo_color = matchingKey.iconModulate
	if !treasureResource.treasureIsFound:
		var newItemInstance = itemScene.instance()
		newItemInstance.connect("item_gone", self, "treasure_looted")
		newItemInstance.itemResource = treasureResource.lootItem
		$chest/ItemPoint.add_child(newItemInstance)
	
func _on_2DPickable_picked(_picker):
	var key : InventoryItem = menu_node.get_instance_property("KeyMenu", "equipedItem", "Equip/EquipSlot")
	if key:
		if key.itemResource == matchingKey:
			menu_node.set_instance_property("KeyMenu", "locked", true, "Equip/EquipSlot")
			key_hole_pickable.active = false
			animation_player.play("open_lid")
			menu_node.close_menu()
#			treasureResource.treasure_is_found()
			emit_signal("treasure_found")

#func _on_2DPickable_picked(_picker):
#	menu_node.set_instance_property("KeyMenu", "locked", true, "Equip/EquipSlot")
#	key_hole_pickable.active = false
#	animation_player.play("open_lid")
#	menu_node.close_menu()
##			treasureResource.treasure_is_found()
#	emit_signal("treasure_found")
		
func _on_KeyHolePickable_picked(_picker):
	menu_node.open_instance("KeyMenu")

func _on_InteractableComponent_interact_opened(player :Player):
	menu_node.set_instance_property("KeyMenu", "inventoryResource", player.playerResource.inventoryResource, "Inventory")

func _on_MenuNode_menu_opened():
	interactable_component.interactScene.mouse.switch(false)

func _on_MenuNode_menu_closed():
	interactable_component.interactScene.mouse.switch(true)


func _on_InteractableComponent_interact_closed(_player):
	menu_node.close_menu()

func set_matching_key(newMatchingKey):
	matchingKey = newMatchingKey

func set_treasure_resource(newTreasureResource : TreasureResource):
	treasureResource = newTreasureResource
	set_matching_key(treasureResource.key)
	if !treasureResource.treasureUnearthed:
		treasureResource.connect("treasure_unearthed", self, "unearth")
	else:
		unearth()

func unearth():
	chest_animation_player.play("Unearth")

func treasure_looted():
	treasureResource.treasure_looted()
