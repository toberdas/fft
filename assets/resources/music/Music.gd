extends Resource
class_name Music

export(int) var BPM = 120
var scale = null
export(Array, Resource) var totalInstruments
export(Curve) var dynamicFalloffCurve
export(NoiseTexture) var noiseTex
export(float) var noiseCutoff = 0.5
export(int) var movements = 10
export(bool) var spatial = false

func get_instrument_and_diff(index):
	var ar = []
	if totalInstruments:
		var ins = totalInstruments[index].instrumentCollection.find_nearest_instrument_and_diff(totalInstruments[index].desiredTone)
		return ins
	else:
		return null




