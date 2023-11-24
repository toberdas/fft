extends Node
class_name ConditionChecker

var cachedNodes = {}

func check_condition(condition:ConditionResource):
	var node
	
	if !cachedNodes.has(condition):
		var parent = get_parent()
		node = parent.find_node(condition.nodeName, true, false)
		cachedNodes[condition] = node
	else:
		node = cachedNodes[condition]
		
	var result = node.call(condition.methodName)
	if result == condition.expectedResult:
		return true
	else:
		return false
