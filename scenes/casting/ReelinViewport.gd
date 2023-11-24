extends Viewport


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _enter_tree():
	get_parent().texture = get_texture()
