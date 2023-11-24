extends Node

var caughtState = preload("res://assets/resources/fish/states/CaughtState.tres")
var currentState = null
var brain : FishBrain

enum localStates{rest, snap, complex, caught}

var localState 

signal brainstate_switched

func _on_Fish_fishready(fish):
	brain = fish.fishData.brain
	currentState = brain.currentState

func _on_NerveNode_nerve_snapped():
	if localState == localStates.rest:
		go_into_snap_state()
	if localState == localStates.snap:
		go_into_complex_state()

func _on_NerveNode_nerve_restored():
	revert_to_neutral_state()

func _on_Fish_caught(_fish):
	go_into_caught_state()

func go_into_caught_state():
	change_brain_state(caughtState)
	brain.stateType = localStates.caught

func go_into_snap_state():
	if !check_if_in_caught_state():
		localState = localStates.snap
		brain.stateType = localStates.snap
		change_brain_state(brain.character.snapState)

func go_into_complex_state():
	if !check_if_in_caught_state():
		localState = localStates.complex
		brain.stateType = localStates.complex
		change_brain_state(brain.character.complexState)

func revert_to_neutral_state():
	if !check_if_in_caught_state():
		localState = localStates.rest
		brain.stateType = localStates.rest
		change_brain_state(brain.character.restState)

func check_if_in_caught_state():
	return brain.currentState == caughtState

func change_brain_state(newstate):
	emit_signal("brainstate_switched", newstate)
	brain.currentState = newstate
