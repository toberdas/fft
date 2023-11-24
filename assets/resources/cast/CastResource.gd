extends Resource
class_name CastResource

var castInstance
var equipResource

var baitItemResource  
var rodItemResource 

var nibblingFish setget set_nibbling_fish
var hookedFish setget set_hooked_fish
var reelinFish setget set_reelin_fish

signal fish_nibbled
signal fish_hooked
signal fish_reeled_in
signal predict_start
signal cast_start
signal cast_done
signal cast_failed

func hooked_fish():
	pass

func done_with_cast():
	emit_signal("cast_done")
	pass

func set_nibbling_fish(fish:Fish):
	pass

func set_hooked_fish(fish:Fish):
	pass

func set_reelin_fish(fish:Fish):
	pass
