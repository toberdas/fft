extends Node


signal on_floor
signal not_on_floor

var groundCount = 1


func _process(_delta):
	var count = 0
	for child in get_children():
		if child.is_colliding():
			count += 1
	if count >= groundCount:
		emit_signal("on_floor")
	else:
		emit_signal("not_on_floor")
