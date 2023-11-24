extends Node

var triggers = []

signal all_triggers_hit

func register_trigger_data(triggerData : TriggerResource):
	triggerData.connect("triggered", self, "check_all_triggers")
	triggers.append(triggerData)

func check_all_triggers():
	for triggerResource in triggers:
		if !triggerResource.triggered:
			return false
	emit_signal("all_triggers_hit")
	return true
		
