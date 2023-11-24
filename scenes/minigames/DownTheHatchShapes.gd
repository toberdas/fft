extends Node2D


func pick_shape():
	randomize()
	var picked = HelperScripts.random_value_from_array(get_children())
	picked.visible = true
	return picked
