extends Resource
class_name TriggerCondition

enum type{none, ordered, timed}

var conditionMet = false setget set_condition_met
signal condition_changed

func process(delta):
	pass

func check_condition():
	return conditionMet

func set_condition_met(newCondition):
	conditionMet = newCondition
	emit_signal("condition_changed", conditionMet)

func triggered(truefalse:bool):
	pass
