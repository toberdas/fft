extends CellularAddition
class_name TriggerAddition

#var triggerConditions = [
#	TriggerCondition, 
#	OrderedTriggerCondition, 
#	TimedTriggerCondition
#]

var triggerConditions = [
	TriggerCondition, 
	OrderedTriggerCondition
]

var triggerResourceList = []
var count = 3

func generate():
	if !islandSave.treasureLooted:
		if cellular.topCells.size() == 0:
			return
		var openTopCells = RandomPickArray.new(cellular.topCells)
		count = min(3, openTopCells.size() - 1)
		var firstTrigger = TriggerResource.new()
		var newTriggerCondition = TriggerCondition.new()
		newTriggerCondition.conditionMet = true
		firstTrigger.triggerCondition = newTriggerCondition
		var firstCell = openTopCells.pick_from_array()
		firstTrigger.location = Vector3.ZERO
		triggerResourceList.append(firstTrigger)
		put_data_in_cell(firstTrigger, firstCell)	
		for i in range (1, count - 1):
			var newTriggerResource = TriggerResource.new()
			var targetCell = openTopCells.pick_from_array()
			newTriggerResource.location = Vector3.ZERO
			var triggerCondition = HelperScripts.random_value_from_array(triggerConditions).new()
			newTriggerResource.triggerCondition = triggerCondition
			
			if triggerCondition is TriggerCondition:
				triggerCondition.conditionMet = true
			if triggerCondition is OrderedTriggerCondition:
				triggerCondition.conditionMet = false
				triggerCondition.previousTrigger = HelperScripts.random_value_from_array(triggerResourceList)
	#		if triggerCondition is TimedTriggerCondition:
	#			triggerCondition.conditionMet = false
	#			var path = cellular.get_point_path(newTriggerResource.location, triggerCondition.previousTrigger.location)
	#			triggerCondition.timeToComplete = 3.0 + path.size() * 2.0
			put_data_in_cell(newTriggerResource, targetCell)	
			triggerResourceList.append(newTriggerResource)

