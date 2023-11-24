extends Node
class_name PlatformPath

var platforms = []
var curve = Curve3D.new()
var connection = null

func _init(character, _connection, pointar):
	connection = _connection
	run(pointar)
	make_platforms(character)

func run(pointar):
	for point in pointar:
		curve.add_point(point)


func make_platforms(character):
	var dist = 0.0
	var curvelen = curve.get_baked_length()
	var previousStep = curve.interpolate_baked(0.0)
	while dist < curvelen:
		var newStep = curve.interpolate_baked(dist)
		var p = IslandPlatform.new(character, newStep, (previousStep - newStep).normalized())
		dist += 7.0
		platforms.append(p)
	pass
