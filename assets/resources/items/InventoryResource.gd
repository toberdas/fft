extends Resource
class_name InventoryResource

export var maxItemsPerLayer = 8
export var minItemsPerLayer = 2 

const ThreeDItemScene = preload("res://scenes/item/3DItem.tscn")

export var itemPickupList : Array

export var topLayerCount = 0
export var layerCount = 0

signal item_equiped
signal item_unequiped

func add_item_from_fishdata(fishdata):
	var fishItemPickupResource = ItemData.make_itemresource_from_fishdata(fishdata)
	itemPickupList.append(fishItemPickupResource)

func pickup_item(_item):
	var pickupResource = PickupItemResource.new()
	pickupResource.itemResource = _item.itemResource
	add_pickup_resource(pickupResource)

func add_pickup_resource(pickupResource : PickupItemResource):
	if pickupResource.is_connected("destroyed", self, "item_destroyed"):
		pickupResource.connect("destroyed", self, "item_destroyed")
	if !pickupResource.is_connected("equiped", self, "item_equiped"):
		pickupResource.connect("equiped", self, "item_equiped")
	pickupResource.pickedUp = true
	itemPickupList.append(pickupResource)

func drop_item(index):
	if index:
		var itemResource = itemPickupList[index]
		if !itemResource.inEquip:
			var threeDitemScene = make_3d_item_from_pickup_resource(itemResource)
			remove_pickup_resource(itemResource)
			return threeDitemScene

func remove_pickup_resource(pickupResource):
	itemPickupList.erase(pickupResource)

func make_3d_item_from_pickup_resource(pickupResource):
	var threeDItemScene = ThreeDItemScene.instance()
	threeDItemScene.itemResource = pickupResource.itemResource
	return threeDItemScene

func from_load(loadedInventoryResource):
	var loadedPickupList = loadedInventoryResource.itemPickupList
	for itemPickup in loadedPickupList:
		var newpickupResource = PickupItemResource.new()
		newpickupResource = newpickupResource.from_load(itemPickup)
		if newpickupResource:
			add_pickup_resource(newpickupResource)

func item_destroyed(pickupResource):
	remove_pickup_resource(pickupResource)

func item_equiped(pickupResource):
	remove_pickup_resource(pickupResource)
