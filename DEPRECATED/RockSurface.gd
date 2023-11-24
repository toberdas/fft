extends Node
class_name RockSurface

var rock = null

var divisions = []
var surfaces = []
var surfaceCount = 0
var surfaceNumber = 1
var maxSurfaces = 6
var minSurfaceSize = .4

func _init(_rock, _character):
	rock = _rock
	start(_rock.transform, _character)

func start(_trans, character):
	divide(Vector2.ZERO, Vector2.ONE, character)
	make_surfaces(divisions, _trans, surfaceNumber, character)
	add_walk(character)

func divide(pos, size, _character):
	var fract = get_fraction()
	surfaceCount += 1
	if surfaceCount < maxSurfaces and size.x > minSurfaceSize and size.y > minSurfaceSize and randf() * _character.density * 2.0 > 1.0 - _character.dynamic or surfaceCount == 1:
		var np1 = pos
		var ns1 = size * (Vector2.ONE - fract.ceil() + fract)
		divide(np1, ns1, _character)
		var np2 = pos + size * fract
		var ns2 = size * (Vector2.ONE - fract)
		divide(np2, ns2, _character)
	else:
		add_division([pos, size, surfaceNumber])

func add_division(divar):
	divisions.append(divar)
	surfaceNumber += 1
	pass

func get_fraction():
	var f = rand_range(0.4,0.6)
	if randf() > 0.5:
		return Vector2(0.0,f)
	else:
		return Vector2(f,0.0)

func make_surfaces(divisions, rocktrans, surfnum, character):
	for division in divisions:
		surfaces.append(Surface.new(division, rocktrans, surfnum, character))
	
func add_walk(character):
	surfaces[-1].walk = Walk.new(character, surfaces[-1])
