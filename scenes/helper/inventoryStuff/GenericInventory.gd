extends Control

signal itemDropped

const inventoryItemScene = preload("res://scenes/inventory/InventoryItem.tscn")

var inventoryResource : InventoryResource

var items = []

func open():
	if !inventoryResource:
		return false
	for dataDicts in inventoryResource.itemDict.values():
		var pickupResource : PickupItemResource = dataDicts["resource"]
		var inventoryItem : InventoryItem = make_inventory_item(pickupResource)
		add_child(inventoryItem)
		items.append(inventoryItem)
		if pickupResource.centerPoint == Vector2.ZERO:
			var newCenterPoint = Vector2($CenterPoint.margin_left, $CenterPoint.margin_top)
			pickupResource.centerPoint = newCenterPoint
			inventoryItem.centerPoint = newCenterPoint
			inventoryItem.position = newCenterPoint

func make_inventory_item(pickupResource : PickupItemResource):
	var item : InventoryItem = inventoryItemScene.instance()
	item.inventory = self
	item.pickupItemResource = pickupResource
	return item

func close():
	for item in items:
		item.queue_free()
