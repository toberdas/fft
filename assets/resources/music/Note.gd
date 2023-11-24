extends Resource
class_name Note

var scale = null
var instrument = null
var interval = 0
var dynamic = 0.0

func _init(_scale = Scale.new()):
	scale = _scale
	
func set_instrument(_instrument):
	instrument = _instrument

func set_interval(_interval):
	interval = _interval

func set_dynamic(_dynamic):
	dynamic = _dynamic
