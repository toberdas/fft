extends Node
class_name SecondOrderDynamics

var xp = Vector3()
var y = Vector3()
var yd = Vector3()

var k1 = 0.0
var k2 = 0.0
var k3 = 0.0
var T_crit = 0.0

func _init(f: float, z: float, r: float, x0: Vector3):
	k1 = z / (PI * f)
	k2 = 1 / ((2 * PI * f) * (2 * PI * f))
	k3 = r * z / (2 * PI * f)
	T_crit = 0.8 * (sqrt(4 * k2 + k1 * k1) - k1)

func update(T, x, xd = null):
	if xd == null:
		xd = (x - xp) / T
		xp = x

	var iterations = int(ceil(T / T_crit))
	T = T / iterations

	for i in range(iterations):
		y = y + T * yd
		yd = yd + T * (x + k3 * xd - y - k1 * yd) / k2

	return y


