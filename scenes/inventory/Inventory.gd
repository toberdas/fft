extends Control

export var maxItemsPerLayer = 8
export var minItemsPerLayer = 2

export(NodePath) var flowField
export(NodePath) var cursor 
export(NodePath) var ui

onready var item_add_control = $VBoxContainer/InventoryUI/ItemAddCenter/ItemAddControl
onready var item_add_node = $VBoxContainer/InventoryUI/ItemAddCenter/ItemAddControl/ItemAddNode

var inventoryResource : InventoryResource

signal item_equiped
signal item_unequiped

var inventoryItemScene = preload("res://scenes/inventory/InventoryItem.tscn")
var items = []
var zLayers = [[]]

signal force_equip

var topLayerCount = 0
var layerCount = 0

var ready = false

func added_to_menu():
	open_and_add_item_nodes()

func _ready():
	flowField = get_node(flowField)
	cursor = get_node(cursor)
	cursor.inventory = self
	ui = get_node(ui)
	ready = true
	open_and_add_item_nodes()

func _enter_tree():
	if ready:
		open_and_add_item_nodes()

func _exit_tree():
	close()

func _on_Inventory_resized():
	for item in items:
		var pos = item.position
		item.centerPoint = item_add_control.rect_position
		item.centerPoint += pos
		pass

func open_and_add_item_nodes():
	if !inventoryResource:
		return false
	for itemPickup in inventoryResource.itemPickupList:
		var inventoryItem : InventoryItem = make_inventory_item(itemPickup)
		item_add_control.add_child(inventoryItem)
		inventoryItem.position += HelperScripts.random_vec2() * 2.0
		items.append(inventoryItem)
		inventoryItem.centerPoint = itemPickup.centerPoint
		

func item_from_equip(item):
	inventoryResource.add_pickup_resource(item.pickupItemResource)
	items.append(item)

func make_inventory_item(pickupResource : PickupItemResource):
	var item : InventoryItem = inventoryItemScene.instance()
	item.inventory = self
	item.pickupItemResource = pickupResource
	return item

func close():
	for item in items:
		if is_instance_valid(item):
			if item is InventoryItem:
				item.queue_free()
	items = []





