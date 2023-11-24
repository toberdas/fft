extends Area2D

var focusedNode = null

signal focused
signal unfocused

func focus_node(node):
	unfocus_node()
	focusedNode = node
	focusedNode.focus()
	emit_signal("focused")

func unfocus_node():
	if focusedNode:
		focusedNode.unfocus()
		focusedNode = null
		emit_signal("unfocused")

func _on_UIChecker2D_area_entered(area):
	if area != focusedNode:
		focus_node(area)

func _on_UIChecker2D_area_exited(area):
	if area == focusedNode:
		unfocus_node()
