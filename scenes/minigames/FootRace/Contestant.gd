extends Node2D

var stepCount = 0

const runningTexture = preload("res://assets/img/icons/runners/runningFigure.png")
const cheeringTexture = preload("res://assets/img/icons/runners/cheeringFigure.png")

func step():
	$Sprite.flip_h = not $Sprite.flip_h
	stepCount += 1
	position.y -= get_parent().stepDistance

func win():
	$Sprite.texture = cheeringTexture

func race_start():
	$Sprite.texture = runningTexture
