extends Resource
class_name Nerve

var counter = 0.0
var limit = 1.0
var metaboliseRate = 0.2

signal snap
signal restore

func _init(_metaboliseRate = 0.1, _limit = 2.0):
	metaboliseRate = _metaboliseRate
	limit = _limit * 6.0

func tick():
	metabolise_nerve()

func metabolise_nerve(factor = 1.0):
	if !check_nerve_depleted():
		counter -= metaboliseRate * factor
	else:
		nerve_restore()

func impact_nerve_counter(impact):
	counter += impact
	if check_if_limit_reached():
		limit_snap()

func check_if_limit_reached(): 
	return counter >= limit

func limit_snap():
	emit_signal("snap")
	
func nerve_restore():
	emit_signal("restore")

func check_nerve_depleted():
	return counter <= 0.0
