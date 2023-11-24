extends CameraGetup

onready var rotator = $Rotator

func _ready():
	mode = "origin"

func set_rotator_params(paramDict: Dictionary):
	HelperScripts.set_node_params(rotator, paramDict)
