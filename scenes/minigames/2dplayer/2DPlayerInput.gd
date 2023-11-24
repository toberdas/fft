extends Node2D


signal input_out

func _process(delta):
	get_movement_vector()

func make_input_dict():
	pass

func get_movement_vector():
	var moveVec = Vector2(Input.get_action_strength("moveright") - Input.get_action_strength("moveleft"), (Input.get_action_strength("movedown") - Input.get_action_strength("moveup")))
	var moveVecNormalized = moveVec.normalized()
	emit_signal("move_out", moveVecNormalized)

func emit_input_dict():
	pass
