extends Node

var targetTimeScale = 1.0
var timeScale = 1.0

func _process(_delta):
	timeScale = move_toward(timeScale, targetTimeScale, 0.2)
	Engine.time_scale = timeScale
