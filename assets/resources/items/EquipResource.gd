extends Resource
class_name EquipResource

export(String) var name = "default"
export(Array, Resource) var equipSlotResources = [] #stores itempickupresource per equipslot, equipslot is the name 0f the instance

#func pickup_resource_in_slot(pickupItemResource, slot):
#	var newEquipSlotResource = EquipSlotResource.new()
#	newEquipSlotResource.pickupItemResource = pickupItemResource
#	newEquipSlotResource.type = slot.equips
#	equipDict[slot.name] = newEquipSlotResource
#
#func remove_slot_item(slot):
#	equipDict.erase(slot.name)

func get_slot_resource(slotName):
	for slotResource in equipSlotResources:
		if slotResource.name == slotName:
			return slotResource

func get_slot_pickup(slotName):
	var slotResource : EquipSlotResource = get_slot_resource(slotName)
	if slotResource:
		return slotResource.pickupItemResource

func remove_slot_pickup(slotName):
	var slotResource = get_slot_resource(slotName)
	if slotResource:
		slotResource.pickupItemResource = null

func get_slot_pickup_and_remove(slotName):
	var pickupResource = get_slot_pickup(slotName)
	remove_slot_pickup(slotName)
	return pickupResource
	
func get_slots_full():
	var fullSlots = []
	for equipSlotResource in equipSlotResources:
		if equipSlotResource.check_if_full():
			fullSlots.append(equipSlotResource)
	return fullSlots			

func get_full_ratio():
	var fullSlotsSize = get_slots_full().size()
	var allSlotsSize = equipSlotResources.size()
	if allSlotsSize > 0:
		return float(fullSlotsSize)/float(allSlotsSize)
	return 0.0

func get_slot_resources():
	return equipSlotResources
	
func check_slot_full(slotName):
	var slotResource : EquipSlotResource = get_slot_resource(slotName)
	if slotResource:
		return slotResource.check_if_full()
