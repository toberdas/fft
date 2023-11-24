extends Node

var time = 0.0 setget ,get_time

func _process(delta):
	time += delta

func get_time():
	return time
