extends Area
class_name SeaHeightComponent

var surfaceHeight = 0.0 setget set_surface_height
var height = 0.0
var dynamics : SecondOrderDynamicsFloat
var active = true

func _ready():
	dynamics = SecondOrderDynamicsFloat.new(0.9,0.6,0.5,height)

func _process(delta):
	if active:
		height = dynamics.update(delta, surfaceHeight, height)
		global_transform.origin.y = height

func set_surface_height(val):
	surfaceHeight = val
