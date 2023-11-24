class_name RandomPickArray

var array = []

func _init(_array):
	array = _array.duplicate()

func pick_from_array():
	var returnvalue
	if array_not_empty():
		var randomindex = get_random_index()
		returnvalue = array.pop_at(randomindex)
	else:
		returnvalue = null
	return returnvalue
	
func array_not_empty():
	return array.size() > 0

func get_random_index():
	return randi() % array.size() 

func size():
	return array.size()
	pass
