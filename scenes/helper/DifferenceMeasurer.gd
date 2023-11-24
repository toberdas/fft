extends Spatial #pass into this a value and get a normalized float between -1 and 1
class_name DifferenceMeasurer

export var upperLimit = 1.0
export var middleValue = 0.0
export var lowerLimit = -1.0

export(Curve) var falloffCurve

func measure_difference_and_calculate_normalized_distance(value):
	var normalizedDifference = 0.0
	if !check_if_value_outside_range(value):
		if check_if_value_above_middle_value(value):
			var absoluteDiffToMiddle = get_value_diff_to_middle_value_from_above(value)
			normalizedDifference = normalize_diff_to_upper_limit(absoluteDiffToMiddle)
			if falloffCurve:
				normalizedDifference = get_point_on_curve(normalizedDifference)
		if check_if_value_below_middle_value(value):
			var absoluteDiffToMiddle = get_value_diff_to_middle_value_from_below(value)
			normalizedDifference = normalize_diff_to_lower_limit(absoluteDiffToMiddle)
			if falloffCurve:
				normalizedDifference = get_point_on_curve(normalizedDifference)
			normalizedDifference = normalizedDifference * -1.0
	else:
		normalizedDifference = get_limit_of_value(value)
	return normalizedDifference

func check_if_value_outside_range(value):
	return value > upperLimit or value < lowerLimit

func check_if_value_above_middle_value(value):
	return value > middleValue

func check_if_value_below_middle_value(value):
	return value < middleValue

func get_value_diff_to_middle_value_from_above(value):
	return value - middleValue

func get_value_diff_to_middle_value_from_below(value):
	return middleValue - value

func normalize_diff_to_upper_limit(diff):
	var distToMiddle = get_distance_between_middle_and_upper_limit()
	return diff / distToMiddle

func normalize_diff_to_lower_limit(diff):
	var distToMiddle = get_distance_between_middle_and_lower_limit()
	return diff / distToMiddle

func get_distance_between_middle_and_upper_limit():
	return upperLimit - middleValue
	
func get_distance_between_middle_and_lower_limit():
	return middleValue - lowerLimit

func get_limit_of_value(value):
	var ret = 0.0
	if value < lowerLimit:
		ret = -1.0
	if value > upperLimit:
		ret = 1.0
	return ret

func get_point_on_curve(normvalue):
	return falloffCurve.interpolate(normvalue)
