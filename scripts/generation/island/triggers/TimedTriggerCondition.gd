extends OrderedTriggerCondition
class_name TimedTriggerCondition

var timeToComplete = 0.0
var timer = 0.0
var timerGoing = false

func process(delta):
	if timerGoing:
		if timer > 0.0 :
			timer -= delta
		else:
			timer = 0.0
			previousTrigger.reset_trigger()
			timerGoing = false
#			set_condition_met(false)

func start_timer():
	timer = timeToComplete
	timerGoing = true

func set_condition_met(newCondition):
	if !conditionMet && newCondition:
		start_timer()
	conditionMet = newCondition
	emit_signal("condition_changed", conditionMet)
	
func triggered(truefalse:bool):
	if truefalse:
		timerGoing = false
