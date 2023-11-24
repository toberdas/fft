extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$IslandNode.init({
		"point" : Vector2(0.5,0.5),
		"tier" : 3,
		"mapSeed" : 123123123
	})
