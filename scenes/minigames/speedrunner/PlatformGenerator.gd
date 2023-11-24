extends Node2D


signal initialize

func _ready():
	emit_signal('initialize', SpeedRunnerData.new())


class SpeedRunnerData:
	var width = 32
	var height = 36
	var screenScale = 48
