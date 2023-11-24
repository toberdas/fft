extends Node
class_name RollCollection

var array = []

func add_value(value, weight):
	var localdict = {
		'value' : value,
		'weight' : weight
	}
	array.append(localdict)

func get_random_value():
	var winningIndex = get_highest_rolling_index()
	return array[winningIndex]['value']

func get_random_value_and_weight():
	var winningIndex = get_highest_rolling_index()
	return array[winningIndex]

func pop_random_value():
	var value = null
	if check_if_array_not_null():
		var winningIndex = get_highest_rolling_index()
		var dictAtIndex = array.pop_at(winningIndex)
		value = dictAtIndex['value']
	else:
		print_debug('RollCollection is empty')
	return value

func get_highest_rolling_index():
	var currentwinner = 0
	var highestroll = 0
	for i in range(array.size()):
		var dict = array[i]
		var roll = throw_dict_dice(dict)
		if roll > highestroll:
			highestroll = roll
			currentwinner = i
	return currentwinner

func throw_dict_dice(dict):
	var d = Dice.new()
	d.add_die(dict['weight'])
	var roll = d.throw_all(false)
	return roll

func check_if_array_not_null():
	return array.size() > 0
