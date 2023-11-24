class_name Switch

var value
var on = false

func _init(_value):
	value = _value

func check_switch(checkvalue):
	if !check_if_value_is_same(checkvalue):
		value = checkvalue
		return switch_and_return_on()
	return null

func check_if_value_is_same(checkvalue):
	return checkvalue == value

func switch_and_return_on():
	on = !on
	return on
