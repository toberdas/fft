extends Node2D


func pick_random_path():
	var randind = randi() % get_child_count()
	return get_child(randind)
