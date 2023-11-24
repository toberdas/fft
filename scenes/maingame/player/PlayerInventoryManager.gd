extends Node


const inventoryScene = preload("res://scenes/inventory/Inventory.tscn")
var inventoryResource : InventoryResource = null
var inventory = null

var open = false

signal instance_out
signal item_equiped_out
signal item_unequiped_out

func _ready():
	GlobalInventory.playerInventory = self
	
func pickup_item(_item):
	inventoryResource.pickup_item(_item)

func _on_ItemPickupNode_pick_up_item(_item):
	inventoryResource.pickup_item(_item)

func _on_Player_damaged(player):
	for _i in range(1 + randi() % 4):
		var randomIndex = HelperScripts.random_index_from_array(inventoryResource.itemPickupList) 
		var threeditem = inventoryResource.drop_item(randomIndex)
		if threeditem:
			get_tree().get_root().add_child(threeditem)
			var location = player.global_transform.origin
			var itemNewLocation = location + Vector3(0,1,0) + HelperScripts.random_vec3() * 2
			threeditem.global_transform.origin = itemNewLocation
			var dir = itemNewLocation - location
			threeditem.apply_impulse(dir * (.6 + randf() * 0.3))

func _on_Player_player_resource_ready(playerResource):
	inventory = inventoryScene.instance()
	emit_signal("instance_out", inventory, "inventory")
	inventoryResource = playerResource.inventoryResource
	inventoryResource.connect("item_equiped", self, "item_equiped")
	inventoryResource.connect("item_unequiped", self, "item_unequiped")
	inventory.inventoryResource = playerResource.inventoryResource

func item_equiped(item):
	emit_signal("item_equiped_out", item)
	
func item_unequiped(item):
	emit_signal("item_unequiped_out", item)

