extends Spatial

onready var inventory = $VBoxContainer/Inventory


func _ready():
	var invRes = InventoryResource.new()
	var pickupres = PickupItemResource.new()
	pickupres.itemResource = preload("res://assets/resources/items/specificItems/bait/CauliflowerMushroom.tres")
	invRes.add_pickup_resource(pickupres)
	inventory.inventoryResource = invRes
	inventory.open_and_add_item_nodes()
