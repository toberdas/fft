extends CellAddition
class_name TriggerResource

var triggerCondition setget set_trigger_condition
var triggered = false setget set_triggered

signal triggered
signal untriggered
signal condition_is_met
signal condition_is_reset

func process(delta):
	triggerCondition.process(delta)

func is_condition_met():
	return triggerCondition.check_condition()

func reset_condition_met():
	triggerCondition.conditionMet = false

func reset_trigger():
	set_triggered(false)

func set_trigger_condition(newCondition : TriggerCondition):
	triggerCondition = newCondition
	triggerCondition.connect("condition_changed", self, "on_condition_met_changed")

func set_triggered(newval):
	triggered = newval
	if newval:
		emit_signal("triggered")
	else:
		emit_signal("untriggered")
	triggerCondition.triggered(newval)

func on_condition_met_changed(newval):
	if newval:
		emit_signal("condition_is_met")
	else:
		emit_signal("condition_is_reset")

func initialize_instance(triggerInstance):
	triggerInstance.triggerResource = self
	return triggerInstance
