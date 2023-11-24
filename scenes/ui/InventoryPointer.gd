extends TwoDPointer
class_name InventoryPointer

var rummaging = false
var picking = 0
var pickedUpItem = null
var inventory = null

func override_process(delta):
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

func action_on_picked(picked):
	if !rummaging:
		pickup(picked.owner)

func pickup(item):
	if is_instance_valid(item):
		if item.get_parent() != self:
			if item.equipSlot:
				var pickupSucces = item.equipSlot.unequip()
				if !pickupSucces:
					return
				item.equipSlot.unequip()
				item.unequip()
				inventory.item_from_equip(item)
	#			
			item.get_parent().remove_child(item)
			add_child(item)
			item.global_position = global_position
			if pickedUpItem:
				drop(pickedUpItem)
			pickedUpItem = item
			picking = 0

func drop(item):
	if is_instance_valid(item):
		var posarea = check_under_mouse_2D_in_group("EquipSlot")
		pickedUpItem = null	
		remove_child(item)
		inventory.add_child(item)
		item.global_position = global_position
		item.centerPoint = global_position
		if posarea:
			drop_on_equip(posarea, item)
	
func drop_on_equip(slotarea, _item):
	var slot = slotarea.get_parent()
	var positem = slot.equip(_item)
	if positem:
		pickup(positem)

func switch(on):
	if on:
		set_process(true)
		switch(true)
	else:
		set_process(false)
		switch(false)
