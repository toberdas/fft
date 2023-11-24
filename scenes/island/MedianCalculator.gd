extends Spatial
class_name MedianCalculator

var values = []

func add_value(val):
	values.append(val)
	return get_median()

func get_median():
	var addup = values[0]
	for value in values:
		addup += value
	addup -= values[0]
	return addup / values.size()
