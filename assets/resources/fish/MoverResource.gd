extends Resource
class_name MoverResource

export var time = 0.0 #how many seconds the mover stays relevant
export var factor = 0.0 #the factor with which the movers force is multiplied
export var distance = 0.0 #distance var used in flee and seek
export var slowdown = 0.0 #slowdown var
export var stop = 0.0
export(int, "seek", "flee", "flock", "nothing", "smartseek") var type

export(bool) var unique = false
export(int) var priority = 0
export(bool) var clears = false
export(bool) var persistent = false

func _init(_time = -1, _factor = 0.5, _distance = 16.0, _slowdown = 2.0, _stop = 0.1, _type = 0, _unique = false, _priority = false, _clears = false, _persistent = false):
	time = _time
	factor = _factor
	distance = _distance
	slowdown = _slowdown
	stop = _stop
	type = _type
	priority = _priority
	unique = _unique
	clears = _clears
	persistent = _persistent
