extends Node2D

var islandData = null

func _ready():
	$UIFocusable.tooltipString = str(islandData.islandSeed)
