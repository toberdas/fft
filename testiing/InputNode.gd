extends Node

signal input_out

func _process(delta):
	var movex = (Input.get_action_strength("moveright") - Input.get_action_strength("moveleft"))
	var movey = (Input.get_action_strength("movedown") - Input.get_action_strength("moveup"))
	emit_signal("input_out", Vector2(movex,movey))
