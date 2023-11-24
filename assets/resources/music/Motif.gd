extends Resource
class_name Motif

var measures = 2
var steps = 3
var bladmuziek = []
var density = 0.5
var unity = 0.5
var dynamic = 0.5
var motifRange = 0
var weight = 0.0
var scale = null
var instruments = [preload("res://assets/resources/music/instruments/A1_Dungeon.tres"), preload("res://assets/resources/music/instruments/A2_Dungeon.tres"), preload("res://assets/resources/music/instruments/A3_bubble.tres")]

func _init(_scale = Scale.new()):
	scale = _scale
	run()

func run():
	density = randf()
	unity = randf()
	dynamic = randf()

	var noteCount = 0
	bladmuziek = []
	motifRange = [-scale.intervals.size(), scale.intervals.size()]
	make_range(unity)
	make_weight(dynamic, density)
	var highestDyn = 0.0
	for measure in measures:
		var distfromton = 0
		var measurar = []
		for step in range(steps):
			if note_hit([measure, step]):
				var dyn = 0.7 + dynamic * 0.25 + (randf() * 0.05)
				if dyn > highestDyn: highestDyn = dyn
				var dist = note_move(distfromton, density)
				distfromton += dist
				var nn = Note.new(scale)
				nn.set_interval(dist)
				nn.set_dynamic(dyn)
				nn.set_instrument(HelperScripts.random_value_from_array(instruments))
				measurar.append(nn)
				noteCount += 1
			else:
				measurar.append(null)
		bladmuziek.append(measurar)
		if measurar[0]:
			measurar[0].dynamic = max(0.4, highestDyn + 0.02)
	if noteCount < 1:
		run()
	else:
		return bladmuziek

func make_range(_unity = randf()):
	var wd = WeightedDistribution.new()
	wd.add_option([1,-1],4)
	wd.add_option([0,0],15)
	wd.add_option([-1, 1],2)
	wd.add_option([-2, 2],1)
	motifRange = HelperScripts.add_up_arrays(motifRange, wd.roll(false))
	
func make_weight(_dynamic = randf(), _density = randf()):
	var wd = WeightedDistribution.new()
	wd.add_option(.1,6)
	wd.add_option(.2,15)
	wd.add_option(.3,3)
	wd.add_option(.6,2)
	weight = wd.roll(false) * (1.0 - _dynamic) * (1.0 + _density)
	

func note_hit(state):
	var h = 0.0
	if state[1] == 0:
		h = .6
	if randf() + h > 1.0 - density:
		return true
	return false
	
func note_move(d, _density = randf()):
	var r = rand_range(motifRange[0], motifRange[1])
	r *= 1.5 - weight
	r += rand_range(-_density * 2.0, (1.0-_density) * 2.0) * weight
	r += d * weight
	r = int(r)
	return r

func mutate():
	for measure in bladmuziek:
		for note in measure:
			if note is Note:
				if randf() > 0.6:
					var intervalDiff = int(rand_range(-2,2))
					note.interval += intervalDiff
				if randf() > 0.2:
					var dynDiff = rand_range(-0.1,0.1)
					note.dynamic += dynDiff
	pass
