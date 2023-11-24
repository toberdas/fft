extends Node
class_name WeightedDistribution

var options = []
var total = 0

func add_option(outcome, weight):
	options.append([outcome, weight])
	total += weight

func roll(takeout = false):
	total = int(total)
	if total > 0:
		var ri = randi() % total
		var t = 0
		for k in options:
			if ri >= t && ri <= t + k[1]:
				if takeout:
					k[1] -= 1
					total -= 1
				return k[0]
			t += k[1]
	else:
		return null

func clear():
	total = 0
	options = []
