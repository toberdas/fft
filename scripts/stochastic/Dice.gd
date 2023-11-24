class_name Dice

var highestPossible = 0 setget ,get_highest_possible
var dice = []

func throw_all(norm = true):
	var t = 0
	for die in dice:
		t += die.throw()
	if norm:
		return float(t) / float(get_highest_possible())
	else:
		return t

func add_die(sides):
	var d = Die.new()
	d.sides = sides
	dice.append(d)
	
class Die:
	var sides = 6
	func throw():
		if sides > 0:
			return randi() % int(sides)
		else:
			return 0.0

func get_highest_possible():
	var t = 0
	for die in dice:
		t += die.sides
	return t
