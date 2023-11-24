extends Resource
class_name Item

export(Resource) var extendedResource
export(Texture) var icon
export(String) var itemName
export(String) var itemID
export(String, MULTILINE) var description
export(String, MULTILINE) var toolTip
export(String, "bait", "rod", "net", "key", "component") var itemType
export(String, "everyday", "strange", "unique", "artifact", "stellar") var rarity
export(Array, Resource) var buffArray = []
export(Color) var iconModulate = Color(1,1,1,1)

export var id = ""
export var currentScene = 0
export var inEquip = false
export var pickedUp = false

func get_type():
	return itemType

func get_taste_array():
	if itemType == 'bait':
		if extendedResource != null:
			return extendedResource.taste

func get_texture_array():
	if itemType == 'bait':
		if extendedResource != null:
			return extendedResource.texture
