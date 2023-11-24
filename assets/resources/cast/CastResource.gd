extends Resource
class_name CastResource

var castInstance
var equipResource : EquipResource

var baitItemResource  
var rodItemResource 

var nibblingFish
var hookedFish
var reelinFish

signal fish_nibbled
signal nibble_ignored
signal fish_hooked
signal fish_reeled_in
signal predict_start
signal cast_start
signal cast_done
signal cast_failed
signal fish_got_away

func hooked_fish():
	emit_signal("fish_hooked", nibblingFish)
	reelinFish = nibblingFish

func nibbled_fish(fish):
	nibblingFish = fish
	emit_signal("fish_nibbled", nibblingFish)

func ignore_nibbling():
	emit_signal("nibble_ignored", nibblingFish)
	nibblingFish = null
	
func got_away():
	emit_signal("fish_got_away", reelinFish)
	reelinFish = null

func reeled_in_fish():
	emit_signal("fish_reeled_in", reelinFish)

func done_with_cast():
	emit_signal("cast_done")
	pass

func set_nibbling_fish(fish:Fish):
	nibblingFish = fish
	pass

func set_hooked_fish(fish:Fish):
	pass

func set_reelin_fish(fish:Fish):
	pass

func get_equiped_bait():
	return equipResource.get_slot_pickup("Bait")

func bait_is_eaten():
	equipResource.remove_slot_pickup("Bait")
