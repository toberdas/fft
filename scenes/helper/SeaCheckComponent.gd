extends Area

signal submerged
signal emerged

var switch : Switch = null

func _ready():
	switch = Switch.new(false)

func submerged(b):
	var check = switch.check_switch(b)
	if check != null:
		if b:
			emit_signal("submerged")
		else:
			emit_signal("emerged")

func is_submerged():
	return switch.value == true

func is_emerged():
	return switch.value == false
