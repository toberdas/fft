class_name UniqueArray

var array = []

func restricted_add(val):
	if !check_if_array_contains_value(val):
		array.append(val)

func check_if_array_contains_value(val):
	var check = array.has(val)
	if check:
		return true
	else:
		return false

func get(index):
	return array[index]
