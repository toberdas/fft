extends Node
class_name NormalDistribution

static func inverse_normal_distribution():
	var d = Dice.new()
	d.add_die(6)
	d.add_die(6)
	d.add_die(6)
	var dx = (d.throw_all(true) -0.5) * 2.0
	var x = sign(dx) - dx
	return x

static func normal_distribution():
	var d = Dice.new()
	d.add_die(6)
	d.add_die(6)
	d.add_die(6)
	return d.throw_all(true)
