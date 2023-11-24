extends Node

var fishData = null
var brain : FishBrain
var nerve : Nerve

signal nerve_snapped
signal nerve_restored

func _on_Fish_fishready(fish):
	brain = fish.fishData.brain
	nerve = fish.fishData.brain.character.nerve
	nerve.connect("snap", self, "emit_nerve_snapped")
	nerve.connect("restore", self, "emit_nerve_restored")
	$NerveTickTimer.wait_time = brain.brainRefresh

func _on_NerveTickTimer_timeout():
	if nerve:
		nerve.tick()

func _on_FishBrainNode_response_out(responseInstance):
	var response = responseInstance.response
	if nerve && brain:
		if check_if_not_complex():
			var actualStrain = get_actual_strain(response.nerveStrain)
			nerve.impact_nerve_counter(actualStrain)
	
func _on_FishAttackNode_release_pressure_from_attack():
	release_pressure(2.0)

func get_actual_strain(strain):
	var nerveMod = get_character_nervousness()
	nerveMod = 1.0 + ((nerveMod - 0.5) * 2.0)
	return strain * nerveMod

func get_character_nervousness():
	return brain.character.nervousness

func check_if_not_complex():
	return !brain.stateType == 2

func emit_nerve_snapped():
	emit_signal("nerve_snapped")
	pass

func emit_nerve_restored():
	emit_signal("nerve_restored")
	pass

func release_pressure(amount):
	nerve.metabolise_nerve(amount)



