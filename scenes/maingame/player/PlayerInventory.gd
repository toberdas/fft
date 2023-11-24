extends Control

var inventoryResource : InventoryResource

onready var item_drop_point = $"../../ItemDropPoint"

export(NodePath) var inventory
export(NodePath) var equip

signal instance_out
signal item_equiped_out
signal item_unequiped_out


func _ready():
	inventory = get_node(inventory)
	equip = get_node(equip)
	GlobalInventory.playerInventory = self
	
func pickup_item(_item):
	inventory.inventoryResource.pickup_item(_item)

func _on_ItemPickupNode_pick_up_item(_item):
	inventory.inventoryResource.pickup_item(_item)

func _on_Player_damaged(player):
	for _i in range(1 + randi() % 4):
		var randomIndex = HelperScripts.random_index_from_array(inventory.inventoryResource.itemPickupList) 
		var threeditem = inventory.inventoryResource.drop_item(randomIndex)
		if threeditem:
			threeditem.dropped(item_drop_point)

func item_equiped(item):
	emit_signal("item_equiped_out", item)
	
func item_unequiped(item):
	emit_signal("item_unequiped_out", item)
	
func load_resource(playerResource : PlayerResource):
	inventoryResource = playerResource.inventoryResource
	inventoryResource.connect("item_equiped", self, "item_equiped")
	inventoryResource.connect("item_unequiped", self, "item_unequiped")
	inventory.inventoryResource = inventoryResource
	equip.equipResource = playerResource.equipResource

func _on_Player_player_resource_ready(playerResource : PlayerResource):
	load_resource(playerResource)
