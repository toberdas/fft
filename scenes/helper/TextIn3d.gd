extends Sprite3D
tool
export var renderText = "" setget set_text

onready var label = $ViewportContainer/Viewport/Label
onready var viewport = $ViewportContainer/Viewport


func _ready():
	set_texture(.get_texture()) 
	label.set_text(renderText)

func set_text(newText):
	renderText = newText
	if !newText is String:
		label.set_text(str(newText))
	else:
		label.set_text(newText)

