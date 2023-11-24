extends Resource
class_name EquipCollectionResource

export(Array) var equipList = []

func get_equip(equipName):
	for equip in equipList:
		if equip.name == equipName:
			return equip
	return null
