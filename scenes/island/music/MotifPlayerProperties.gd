class_name MotifPlayerProperties

var spatial = false
var measureDuration = 1.0
var dynamicBase = 1.0
var durationVariance = 1.0
var startVariance = 1.0
var reverseVariance = 1.0
var durationSubtract = 0.0

func _init(_spatial = false, _dynamicBase = 1.0, _durationVariance = 1.0, _startVariance = 1.0, _reverseVariance = .5, _durationSubtract = 0.0):
	spatial = _spatial
	dynamicBase = _dynamicBase
	durationVariance = _durationVariance
	startVariance = _startVariance
	reverseVariance = _reverseVariance
	durationSubtract = _durationSubtract
