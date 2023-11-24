class_name TimerDictionary

var dict = {}
var maxItems = 12

func add_item_with_key_time(item, key, time):
	if dict.size() > maxItems:
		dict.erase(HelperScripts.random_key_from_dict(dict))
	dict[key] = {
		"item" : item,
		"time" : time
	}


func tick_time(delta):
	for key in dict.keys():
		dict[key]["time"] -= delta
		if dict[key]["time"] <= 0.0:
			remove_item_at_key(key)

func remove_item_at_key(key):
	dict.erase(key)

func get_item(key):
	return dict[key]["item"]

func has(key):
	return dict.has(key)
