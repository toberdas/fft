extends TriggerCondition
class_name OrderedTriggerCondition

var previousTrigger setget set_previous_trigger

func set_previous_trigger(newPreviousTrigger : TriggerResource):
	previousTrigger = newPreviousTrigger
	previousTrigger.connect("triggered", self, "set_condition_met", [true])
	previousTrigger.connect("untriggered", self, "set_condition_met", [false])
