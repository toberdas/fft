extends DifferenceMeasurer

export var minDecibel = -12.0
export var maxDecibel = 6.0

func _on_WorldPlayerTracker_emit_player_global_transform(playerGlobalTransform):
	if playerGlobalTransform:
		var normDiff = measure_difference_and_calculate_normalized_distance(playerGlobalTransform.origin.y)
		var seaDecibels = get_sea_bus_decibels_from_diff(normDiff)
		var windDecibels = get_wind_bus_decibels_from_diff(normDiff)
		set_bus_decibels('Sea', seaDecibels)
		set_bus_decibels('Wind', windDecibels)
	
func get_sea_bus_decibels_from_diff(diff):
	var decibels = 0.0
	if diff > 0.0:
		decibels = diff * minDecibel
	else:
		decibels = -diff * maxDecibel
	return decibels

func get_wind_bus_decibels_from_diff(diff):
	var decibels = 0.0
	if diff < 0.0:
		decibels = -diff * minDecibel
	else:
		decibels = diff * maxDecibel
	return decibels

func set_bus_decibels(busname, decibels):
	var busIndex = AudioServer.get_bus_index(busname)
	var oldVolume = AudioServer.get_bus_volume_db(busIndex)
	var newVolume = lerp(oldVolume, decibels, 0.2)
	AudioServer.set_bus_volume_db(busIndex, newVolume)
