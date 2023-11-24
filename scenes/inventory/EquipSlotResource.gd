extends Resource
class_name EquipSlotResource

export(String) var name = "Slot"
export(String, MULTILINE) var tooltip = ""
export(Resource) var pickupItemResource = null
export(String, "bait", "rod", "net", "key", "component") var equips = "bait"
export(bool) var locks = false
export(Resource) var unlocksOn = null
export(bool) var locksPrevious = false
export(bool) var locked = false


func check_if_full():
	return pickupItemResource != null
