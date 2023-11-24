extends Node
class_name ConditionCheck

static func check_from_root(condition:ConditionResource, rootNode:Node):
	var conditionChecker = rootNode.get_node("ConditionChecker")
	assert(conditionChecker)
	return conditionChecker.check_condition(condition)

static func check_from_child(condition:ConditionResource, startNode:Node):
	var nodeOwner = startNode.owner
	var conditionChecker = nodeOwner.get_node("ConditionChecker")
	assert(conditionChecker)
	return conditionChecker.check_condition(condition)
