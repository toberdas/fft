extends Resource
class_name Scale

export(String) var name = "scale"
export(Array, int) var intervals = []
var stepsPerOctave = 12 setget ,get_total_intervals
var tonic = 0.0
var stepTonic = 314
var exponent = 0.0 setget ,get_exponent
var character = null

func generate():
	if character:
		make_steps(character.unity)
		make_intervals()
		make_tonic(character.density)
	else:
		make_steps(randf())
		make_intervals()
		make_tonic(randf())

func get_total_intervals():
	var w = 0
	if intervals:
		for inter in intervals:
			w += inter
		return w
	else:
		return null

func get_exponent():
	var w = 2.0
	if intervals:
		w = pow(w, 1.0/get_total_intervals())
		return w
	else:
		return null
	

func get_interval_sum(currentind, steps, direction):
	var som = 0
	var i = currentind
	for _x in range(steps):
		if direction == 1:
			som += intervals[i % intervals.size()]
			i += direction
		else:
			i += direction
			som += intervals[i % intervals.size()]
	return som * direction

func make_steps(unity = 0.5):
	var wd = WeightedDistribution.new()
	wd.add_option(12, int(85 * unity))
	wd.add_option(13, 10)
	wd.add_option(14, 3)
	wd.add_option(15, 2)
	stepsPerOctave = wd.roll(true)

func make_intervals():
	var wd = WeightedDistribution.new()
	wd.add_option(5, 60)
	wd.add_option(4, 30)
	wd.add_option(7, 9)
	wd.add_option(8, 1)
	var intervalAmount = wd.roll(true)
	
	intervals = []
	var idInt = float(stepsPerOctave) / float(intervalAmount)
	wd.clear()
	wd.add_option(3,4)
	wd.add_option(2,7)
	wd.add_option(1,7)
	wd.add_option(0,15)
	wd.add_option(-1,7)
	for i in intervalAmount:
		intervals.append(max(1, int(idInt) + wd.roll(true)))
	while HelperScripts.accumulate_array(intervals) > stepsPerOctave:
		var ri = randi() % intervals.size()
		if intervals[ri] > 1:
			intervals[ri] -= 1
	while HelperScripts.accumulate_array(intervals) < stepsPerOctave:
		var ri = randi() % intervals.size()
		intervals[ri] += 1

func make_tonic(density = 0.5):
	var t = randi() % stepsPerOctave - int(stepsPerOctave / 2)
	tonic = int(t * (1.0 - density))
