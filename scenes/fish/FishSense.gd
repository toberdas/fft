extends Spatial

signal flee

signal dangersensed
signal identifiedsensed 

var ready = false

func _ready():
	$Timer.wait_time = 1.5 + randf()

func _on_Fish_fish_deactivated():
	ready = false
#	$DangerArea.switch_state("off")
#	$FOAreaEmitter.switch_state("off")


func _on_Fish_fish_activated():
	ready = true
#	$DangerArea.switch_state("out")
#	$FOAreaEmitter.switch_state("out")


func _on_SenseArea_body_entered(body):
	if ready:
		emit_body(body)


func _on_Timer_timeout():
	if ready:
		var bodies = $SenseArea.get_overlapping_bodies()
		for body in bodies:
			emit_body(body)

func emit_body(body):
	if body != get_parent():
		if body.is_in_group("ScaryToFish"):
			emit_signal("dangersensed", body)
		else:
			emit_signal("identifiedsensed", body)
