extends Spatial


func _process(delta):
	if Input.is_action_just_pressed("action"):
		test()

func test():
	test_diff_measure()

func test_diff_measure():
	var ra = rand_range(-20.0,20.0)
	var normdiff = $DifferenceMeasurer.measure_difference_and_calculate_normalized_distance(ra)
	print(ra)
	print(normdiff)
