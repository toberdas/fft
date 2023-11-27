extends Area
class_name SeaHeightComponent

export var setsOwnHeight = true

export var a = 0.9
export var b = 0.6
export var c = 0.5

export var clampHeight = false
export var minHeight = 0.0
export var maxHeight = 0.0

var surfaceHeight = 0.0 setget set_surface_height
var height = 0.0
var dynamics : SecondOrderDynamicsFloat
export var active = true

func _ready():
	dynamics = SecondOrderDynamicsFloat.new(a,b,c,height)

func _process(delta):
	if active:
		height = dynamics.update(delta, surfaceHeight, height)
		if clampHeight:
			height = clamp(height, minHeight, maxHeight)
		if setsOwnHeight:
			global_transform.origin.y = height
	else:
		height = 0

func set_surface_height(val): ##THIS IS CALLED BY ENDLESS SEA!!
	surfaceHeight = val
