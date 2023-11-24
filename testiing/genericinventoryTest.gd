extends Spatial



func _ready():
	var invRes = InventoryResource.new()
	var pickupres = PickupItemResource.new()
	pickupres.itemResource = preload("res://assets/resources/items/specificItems/bait/CauliflowerMushroom.tres")
	invRes.add_item_to_dict(pickupres)
	$GenericInventory.inventoryResource = invRes
	$GenericInventory.open()
