extends Node

export var barThickness = 90

onready var barUp = $BarUp
onready var barDown = $BarDown

signal letterbox_done

func _ready():
	var windowsize = OS.window_size
	barUp.rect_size = Vector2(windowsize.x, barThickness)
	barUp.rect_position = Vector2(0, -barThickness)
	barDown.rect_size = Vector2(windowsize.x, barThickness)
	barDown.rect_position = Vector2(0, windowsize.y)
	

func letterbox(onoff):
	var windowsize = OS.window_size
	if onoff:
		var tween = get_tree().create_tween()
		tween.tween_property(barUp, "rect_position", Vector2(0,0), 2)
		tween.parallel().tween_property(barDown, "rect_position", Vector2(0,windowsize.y - barThickness), 1)
		tween.tween_callback(self, "done_callback")
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(barUp, "rect_position", Vector2(0, -barThickness), 2)
		tween.parallel().tween_property(barDown, "rect_position", Vector2(0, windowsize.y), 1)
		tween.tween_callback(self, "done_callback")

func done_callback():
	emit_signal("letterbox_done")
