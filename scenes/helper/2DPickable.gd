extends Area2D
class_name TwoDPickable

signal picked

func picked(picker):
	emit_signal("picked", picker)
