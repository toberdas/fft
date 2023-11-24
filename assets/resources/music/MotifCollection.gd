extends Resource
class_name MotifCollection

var amount = 0
var randomMotifs = []
var eventMotifs = {} ##TODO: eventmotifs aan laten maken, moeten een smaakje krijgen
var spacing = 0.0
var variance = 0.0

func _init(scale = Scale.new()):
	run(scale)

func run(scale):
	make_amount()
	make_spacing()
	make_variance()
	make_motifs(scale)

func make_amount():
	var d = Dice.new()
	d.add_die(10)
	d.add_die(10)
	d.add_die(10)
	amount = int(d.throw_all(true) * 2.0 + 1.0)

func make_spacing():
	var d = Dice.new()
	d.add_die(10)
	d.add_die(10)
	d.add_die(10)
	spacing = d.throw_all(true) * 6.0 + 6.0

func make_variance():
	var d = Dice.new()
	d.add_die(10)
	d.add_die(10)
	d.add_die(10)
	variance = d.throw_all(true)

func make_motifs(scale):
	for _i in range(amount):
		randomMotifs.append(Motif.new(scale))
