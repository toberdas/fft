extends Resource
class_name TotalInstrument

export(float) var desiredTone
export(int) var intervalRange = 12
export(int) var movementLength = 8
export(Curve) var curveDynamic
export(Curve) var cutoffCurve
export(Array, float) var fractionArray
export(AudioStream) var sound
export(float) var soundTone
export(float) var volatility = 0.1
var toneScale = 0.0 setget ,get_tone_diff
export(float) var swing = 0.001

func get_tone_diff():
	return desiredTone / soundTone

