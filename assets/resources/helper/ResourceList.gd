extends Resource
class_name ResourceList

export(Array, Resource) var resourceList

func get_random_item():
	return HelperScripts.random_value_from_array(resourceList)

func get(index):
	if index < resourceList.size():
		return resourceList[index]
	else:
		return false
