extends Resource
class_name InstrumentCollection

export(String) var name
export(Array, Resource) var instrumentArray

func find_nearest_instrument_and_diff(idealtone):
	var diff = 100.0
	var best = null
	for instrument in instrumentArray:
		var thisdiff = instrument.tone - idealtone
		if abs(thisdiff) < abs(diff):
			best = instrument
			diff = thisdiff
	return [best, diff]		 
