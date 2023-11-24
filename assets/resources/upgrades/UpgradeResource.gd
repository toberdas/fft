extends Resource
class_name UpgradeResource

export(Resource) var equipResource = EquipResource.new()
export(String) var name
export(String) var label
export(String, MULTILINE) var tooltip
export(Array, Resource) var parameters

func get_progress_ratio():
	if equipResource:
		return equipResource.get_full_ratio()
	return 0.0

func get_progress():
	if equipResource:
		return equipResource.get_slots_full().size()
	return 0

func check_if_equip_full(equipSlotName):
	return equipResource.check_slot_full(equipSlotName)
