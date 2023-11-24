class_name ProcessTimer

var time
var maxTime
var tickTime = 1.0

func _init(_time):
	maxTime = _time
	time = _time

func tick():
	var r = false
	time -= tickTime
	if time <= 0.0:
		r = true
	return r

func reset():
	time = maxTime

func is_timed_out():
	return time <= 0.0
