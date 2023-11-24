extends Control


const inventoryItemScene = preload("res://scenes/inventory/InventoryItem.tscn")
const equipSlotScene = preload("res://scenes/inventory/EquipSlotScene.tscn")
export(Resource) var equipResource = EquipResource.new()
var slotDict = {}

var firstOpen = true

func open_and_add_item_nodes():
	if !equipResource:
		return
	for equipSlotResource in equipResource.get_slot_resources():
		if !slotDict.has(equipSlotResource.name):
			add_equip_slot_node(equipSlotResource)
	for equipSlotResource in equipResource.get_slot_resources():
		if !slotDict.has(equipSlotResource.name):
			return
		var equipSlot = slotDict[equipSlotResource.name]
		var equipedItemResource = equipSlotResource.pickupItemResource
		if equipedItemResource:
			var item = make_inventory_item(equipedItemResource)
			equipSlot.put_in_slot(item)

func add_equip_slot_node(equipSlotResource):
	var equipSlotSceneInstance = equipSlotScene.instance()
	var equipSlot = equipSlotSceneInstance.get_node("CenterControl/EquipSlot")
	equipSlot.connect("item_equiped",self,"add_item_to_resource")
	equipSlot.connect("item_unequiped",self,"remove_item_from_resource")
	equipSlot.equipSlotResource = equipSlotResource
	add_child(equipSlotSceneInstance)
	slotDict[equipSlotResource.name] = equipSlot

func make_inventory_item(pickupResource : PickupItemResource):
	var item : InventoryItem = inventoryItemScene.instance()
	item.inventory = self
	item.pickupItemResource = pickupResource
	return item

func _enter_tree():
	open_and_add_item_nodes()

func _exit_tree():
	clear_equips()

func clear_equips():
	for key in slotDict:
		slotDict[key].empty_slot()

func add_item_to_resource(slot, item):
#	equipResource.pickup_resource_in_slot(item.pickupItemResource, slot)
	pass
	
func remove_item_from_resource(slot, item):
#	equipResource.remove_slot_item(slot)
	pass

func get_slot(slotName):
	if slotDict.has(slotName):
		return slotDict[slotName]

func get_item_from_slot(slotName):
	var slot = get_slot(slotName)
	if slot:
		return slotDict[slotName].equipedItem

func get_and_destroy_item_from_slot(slotName):
	var item = get_item_from_slot(slotName)
	if item:
		slotDict[slotName].destroy_equiped()
		return item

func set_all_equipslots_tooltip_target(target):
	for slotName in slotDict:
		var slotScene = slotDict[slotName]
		slotScene.set_tooltip_target(target)
	pass
