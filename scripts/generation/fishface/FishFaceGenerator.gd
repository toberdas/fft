extends TextureRect

export var d_foreheadToEye = 256.0
export var s_eye = 120.0
export var silhouetteScale = 300.0
export var d_mouthToCorner = 36.0
export var s_eyeSize = 120.0
export var mouthScale = 120.0

var foreheadPoint = Vector2.ZERO
var mouthPoint = Vector2.ZERO
var chinPoint = Vector2.ZERO
var mouthCornerPoint = Vector2.ZERO
var mouthOpeningPoint = Vector2.ZERO
var eyePoint = Vector2.ZERO
var eyebrowStartPoint = Vector2.ZERO
var eyebrowEndPoint = Vector2.ZERO

func _ready():
	$Viewport.size = get_tree().get_root().get_viewport().size

func run(fishData : FishData):
	seed(fishData.fishSeed)
	texture = $Viewport.get_texture()
	$Viewport/PolygonGenerator.clear()
	$Viewport/CurveGenerator.run(fishData.color)

