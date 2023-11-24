extends Resource
class_name FishData

var caught = false

var baitPreference = ["sweet"]
var gameCollection = null
var gameDifficulty = 1
export var fishCurve = preload("res://assets/curves/test_curve1.tres")
var speed = 1.0
var evadeFactor = 0.0
var flowFactor = 0.5
var fishSize = .5
var fishLives = 0 
var mass = 0.5
var pointList = []
var spawnPoint : Vector3
var motif : Motif
var scale : Scale
var color : Color setget ,get_color
var texture : Texture
var brain : FishBrain
var foreignSeed = 0
var fishSeed = 0
var parentFishSeed = 0 ##TODO inbouwen parent fish
var gameWon = false
var fragmentActivated = false
var fragmentAcquiered = false
var buffCollection : Resource
var meshCurves : Resource
var parentIslandPoint : Vector2
var scene = null

const allTextures = preload("res://assets/resources/fish/AllFishTextures.tres")

func _init(_fishSeed = hash(randf()), _foreignSeed = hash(randf())):
	foreignSeed = _foreignSeed
	fishSeed = _fishSeed

func generate():
	color = make_color()
	texture = make_texture()
	motif = make_motif()
	brain = make_brain()
	meshCurves = make_mesh_curves()
	seed(fishSeed)
	speed = 0.4 + randf() * 0.6
	evadeFactor = 1.0
	flowFactor = 0.2 + randf() * .2
	mass = .1 + randf() * .3
	buffCollection = BuffCollection.new()

func make_color():
	seed(foreignSeed)
	var rancol = Color(randf(),randf(),randf())
	seed(fishSeed)
	var ranOwnCol = Color(randf(),randf(),randf())
	return rancol.linear_interpolate(ranOwnCol, 0.1)

func make_texture():
	seed(foreignSeed)
	return HelperScripts.random_value_from_array(allTextures.resourceList)

func make_brain():
	seed(fishSeed)
	var _brain = FishBrain.new()
	_brain.fishSeed = fishSeed
	_brain.generate()
	return _brain

func make_motif():
	seed(foreignSeed)
	var _scale = Scale.new()
	_scale.generate()
	var _motif = Motif.new(_scale)
	seed(fishSeed)
	_motif.mutate()
	return _motif

func set_pointlist(_pointList):
	seed(fishSeed)
	pointList = _pointList
	if pointList:
		spawnPoint = HelperScripts.random_value_from_array(pointList) + Vector3(0,2,0)

func set_parent_island_point(point : Vector2):
	parentIslandPoint = point

func make_mesh_curves():
	seed(foreignSeed)
	var _meshCurves = FishMeshCurveData.new()
	seed(fishSeed)
	_meshCurves.mutate()
	return _meshCurves

func get_color():
	return color

