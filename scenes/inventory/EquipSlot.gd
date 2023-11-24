extends Node2D
class_name EquipSlot

export(Resource) var equipSlotResource setget set_equipslot_resource

const inventoryItemScene = preload("res://scenes/inventory/InventoryItem.tscn")

var equipedItem = null
var locked = false

signal item_equiped
signal item_unequiped

func _ready():
	if equipSlotResource:
		$Label.text = equipSlotResource.name

func _enter_tree():
	if equipSlotResource:
		$Label.text = equipSlotResource.name
	
func equip(_item):
	if locked:
		return
	if equipSlotResource.unlocksOn:
		if !equipSlotResource.unlocksOn.check_if_full():
			return
	if _item.pickupItemResource.itemResource.itemType != equipSlotResource.equips:
		return null
	
	var returnItem = equipedItem
	if returnItem:
		unequip()
	equipedItem = inventoryItemScene.instance()
	equipedItem.pickupItemResource = _item.pickupItemResource
	equipedItem.equip(self)
	put_in_slot(equipedItem)
	_item.queue_free()
	
	equipSlotResource.pickupItemResource = equipedItem.pickupItemResource
	emit_signal("item_equiped", self, equipedItem)
	return returnItem

func put_in_slot(item):
	item.pickupItemResource.inEquip = true
	add_child(item)
	item.equipSlot = self
	equipSlotResource.pickupItemResource = item.pickupItemResource
	if equipSlotResource.locks: equipSlotResource.locked = true

func empty_slot():
	for child in get_children():
		if child is InventoryItem:
			child.queue_free()

func equip_from_load(_item):
	if _item.pickupItemResource.itemResource.itemType != equipSlotResource.equips:
		return null
	var returnItem = equipedItem
	if returnItem:
		unequip()
	equipedItem = _item
	equipedItem.equip(self)
	return returnItem

func unequip():
	if !equipSlotResource.locked:
		equipSlotResource.pickupItemResource = null
		emit_signal("item_unequiped", self, equipedItem)
		equipedItem = null
		return true
	return false

func _on_Inventory_force_equip(item):
	equip_from_load(item)
	
func destroy_equiped():
	if equipedItem:
		equipSlotResource.pickupItemResource = null
		emit_signal("item_unequiped", self, equipedItem)
		equipedItem.queue_free()

func set_equipslot_resource(newEquipslotResource : EquipSlotResource):
	equipSlotResource = newEquipslotResource

func set_tooltip_text(text):
	$UIFocusable.tooltipString = text

func set_tooltip_target(target):
	set_tooltip_text(equipSlotResource.tooltip)
	$UIFocusable.toolTipTarget = target
