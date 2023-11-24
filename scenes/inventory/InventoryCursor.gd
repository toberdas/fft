extends TwoDPlayerMover

var rummaging = false

var picking = 0
var pickedUpItem = null

onready var area = $Area2D

func _process(delta):
	if Input.is_action_pressed("rummage_inventory"):
		rummaging = true
	if Input.is_action_just_released("rummage_inventory"):
		rummaging = false
	if Input.is_action_just_pressed("inventory_pick"):
		picking = 10
	if Input.is_action_just_pressed("inventory_drop"):
		if pickedUpItem:
			drop(pickedUpItem)
	if picking > 0: picking -= 1
	
	var b = area.get_overlapping_bodies()
	if b:
		var i = b.front()
		if i.is_in_group("Item") && !rummaging:
			get_parent().ui.focus_item(i)
			if picking > 0:
				pickup(i)
	else:
		get_parent().ui.focus_item(null)

func pickup(item):
	if item.get_parent() != self:
		if item.equipSlot:
			item.equipSlot.unequip()
		item.get_parent().remove_child(item)
		add_child(item)
		item.global_position = global_position
		pickedUpItem = item
		picking = 0

func drop(item):
	var posarea = check_under_mouse()
	pickedUpItem = null	
	remove_child(item)
	get_parent().add_child(item)
	item.global_position = global_position
	item.centerPoint = global_position
	if posarea:
		drop_on_equip(posarea, item)
	
func drop_on_equip(slotarea, _item):
	var slot = slotarea.get_parent()
	var positem = slot.equip(_item)
	if positem:
		pickup(positem)

func check_under_mouse():
	var ars = area.get_overlapping_areas()
	for ar in ars:
		if ar.get_parent().is_in_group("EquipSlot"):
			return ar
	return false
