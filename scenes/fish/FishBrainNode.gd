extends Spatial

var brain = null
var fishData = null
var followPoint = null

signal braintick
signal brainstate_switched
signal response_out

var timer = 0.0
var tickTime = 4.0

func _process(delta):
	timer += delta
	if timer > tickTime:
		tick_brain()
		timer = 0.0

func _on_Timer_timeout():
#	tick_brain()
	pass

func tick_brain():
	if fishData:
		var pl = fishData.pointList ##list of points on island filled when data is made
		if pl:
			if followPoint:
				var rp = pl[randi() % pl.size()]
				followPoint.transform.origin = rp
				react_to_situation("relocate", followPoint)

func _on_Fish_fishready(fish):
	fishData = fish.fishData
	brain = fishData.brain
	followPoint = fish.followPoint
	$RelocateTimer.wait_time = brain.brainRefresh
	tickTime = brain.brainRefresh

func _on_SenseBrain_situation_sense(body, situation):
	react_to_situation(situation, body)

func react_to_situation(situation, body):
	var _response = get_response_from_brain_state_or_null(situation)
	if _response:
		var responseInstance = ResponseInstance.new()
		responseInstance.response = _response
		responseInstance.body = body
#		var response = _response.duplicate()
#		response.body = body
		emit_signal("response_out", responseInstance)

func get_response_from_brain_state_or_null(situation):
	var state : BrainState = get_brain_state()
	var response = state.get_fitting_response_to_situation(situation)
	return response

func get_brain_state():
	return brain.currentState	



