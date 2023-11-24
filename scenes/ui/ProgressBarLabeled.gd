extends MarginContainer

export var text = ""
onready var progress = 0.0 setget set_progress, get_progress
onready var maxValue = 0.0 setget set_max_value, get_max_value

onready var label = $VBoxContainer/Label
onready var progressBar = $VBoxContainer/ProgressBar

func _ready():
	set_text(text)
	set_progress(0)

func set_text(txt):
	if is_instance_valid(label):
		label.set_text(txt)

func set_progress(val):
	if is_instance_valid(progressBar):
		progressBar.set_value(val)

func get_progress():
	if is_instance_valid(progressBar):
		return progressBar.value
	else:
		return -1
		
func set_max_value(val):
	if is_instance_valid(progressBar):
		progressBar.max_value = val
	
func get_max_value():
	if is_instance_valid(progressBar):
		return progressBar.max_value
	else:
		return -1
