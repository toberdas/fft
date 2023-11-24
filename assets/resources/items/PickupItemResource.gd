extends Resource
class_name PickupItemResource

export var itemResource : Resource
export var id = ""
export var inEquip = false
export var pickedUp = false
export var ignoreSave = false
export var centerPoint = Vector2.ZERO

signal equiped
signal unequiped
signal destroyed

func from_load(pickupResource):
	if !pickupResource.ignoreSave:
		itemResource = pickupResource.itemResource
		id = pickupResource.id
		inEquip = pickupResource.inEquip
		pickedUp = pickupResource.pickedUp
		ignoreSave = pickupResource.ignoreSave
		centerPoint = pickupResource.centerPoint
		return self
	else:
		return null

func get_type():
	return itemResource.itemType

func get_taste_array():
	if itemResource.itemType == 'bait':
		if itemResource.extendedResource != null:
			return itemResource.extendedResource.taste

func get_texture_array():
	if itemResource.itemType == 'bait':
		if itemResource.extendedResource != null:
			return itemResource.extendedResource.texture

func equip():
	emit_signal("equiped", self)
	pass

func unequip():
	pass

func destroy():
	emit_signal("destroyed", self)
	pass
