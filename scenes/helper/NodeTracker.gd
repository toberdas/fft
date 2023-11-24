extends Node
class_name NodeTracker

export(NodePath) var nodeToTrack setget set_node_to_track,get_node_to_track

func _ready():
	if nodeToTrack:
		if nodeToTrack is NodePath:
			nodeToTrack = get_node(nodeToTrack)

func set_node_to_track(node):
	nodeToTrack = node

func get_node_to_track():
	return nodeToTrack

func get_node_global_transform():
	if check_if_node():
		if check_if_node_has_transform():
			return nodeToTrack.global_transform

func get_node_global_transform_y():
	var global_transform = get_node_global_transform()
	return global_transform.origin.y

func get_node_property(property : String):
	if check_if_node_has_property(property):
		return nodeToTrack.get(property)

func check_if_node_has_property(property : String):
	return nodeToTrack.get(property)

func check_if_node_has_transform():
	return check_if_node_has_property('transform')

func get_node_position():
	return nodeToTrack.position

func get_node_global_position():
	return nodeToTrack.global_position

func check_if_node():
	if nodeToTrack:
		return true
	else:
		return false
