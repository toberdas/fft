extends Node2D

export var d_foreheadToEye = 256.0
export var s_eye = 120.0
export var s_silhouette = 300.0
export var d_mouthToCorner = 36.0
export var s_eyeSize = 120.0
export var s_mouthScale = 120.0

signal to_polygon
#signal to_draw
#signal curves_done

var foreheadPoint = Vector2.ZERO
var mouthPoint = Vector2.ZERO
var chinPoint = Vector2.ZERO
var mouthCornerPoint = Vector2.ZERO
var mouthOpeningPoint = Vector2.ZERO
var eyePoint = Vector2.ZERO
var eyebrowStartPoint = Vector2.ZERO
var eyebrowEndPoint = Vector2.ZERO

var topCurve = Curve2D.new()
var bottomCurve = Curve2D.new()
var upperLipCurve = Curve2D.new()
var bottomLipCurve = Curve2D.new()
var mouthLineCurve = Curve2D.new()
var mouthLineCurve2 = Curve2D.new()
var eyeCurve = Curve2D.new()
var pupilCurve = Curve2D.new()
var underEyeCurve = Curve2D.new()
var underEyeCurve2 = Curve2D.new()
var eyebrowCurve = Curve2D.new()
var eyebrowCurve2 = Curve2D.new()

func run(color):
	if is_inside_tree():
		topCurve = Curve2D.new()
		bottomCurve = Curve2D.new()
		upperLipCurve = Curve2D.new()
		bottomLipCurve = Curve2D.new()
		mouthLineCurve = Curve2D.new()
		mouthLineCurve2 = Curve2D.new()
		eyeCurve = Curve2D.new()
		pupilCurve = Curve2D.new()
		underEyeCurve = Curve2D.new()
		underEyeCurve2 = Curve2D.new()
		eyebrowCurve = Curve2D.new()
		eyebrowCurve2 = Curve2D.new()
		
		var s = get_tree().get_root().get_viewport().size
		mouthPoint.x = s.x * 0.45
		mouthPoint.y = s.y * 0.5
		mouthPoint += HelperScripts.random_vec2() * 160.0
		mouthOpeningPoint = mouthPoint + Vector2(16.0, -24.0) + HelperScripts.random_vec2() * 12.0
		chinPoint.y = s.y * (0.8 + randf() * 0.1)
		foreheadPoint.y = s.y * randf() * 0.1
		s_mouthScale = s.x / 17.0
		s_silhouette = s.y * 0.3
		make_top_curve()
		make_bottom_curve()
		
		var inter = rand_range(0.2,0.4)
		var dist = bottomCurve.interpolate(0, 1.0 - inter) - topCurve.interpolate(0, inter)
		var ratio = rand_range(.4,.6)
		
		d_foreheadToEye = dist.y * ratio
		s_eyeSize = (dist.y  - d_foreheadToEye) * (.2 + randf() * .3) - 6.0
		eyePoint = topCurve.interpolate(0, inter) + Vector2(0.0, d_foreheadToEye) 
		
		mouthCornerPoint = bottomCurve.interpolate(0, 0.1 + randf() * 0.4) - Vector2(d_mouthToCorner, d_mouthToCorner * 0.5)
		
		eyebrowStartPoint = topCurve.interpolate(0, inter) + Vector2(-64.0, d_foreheadToEye * (randf() * 0.6))
		var eyebrowadd = .05 + randf() * 0.2
		var edist = bottomCurve.interpolate(0, 1.0 - inter + eyebrowadd) - topCurve.interpolate(0, inter + eyebrowadd)
		var rat = randf() * 0.2
		eyebrowEndPoint = topCurve.interpolate(0, inter + eyebrowadd) + Vector2(0.0, edist.y * rat)
		
		make_lip_curves()
		make_eye_curve()
		
		if randf() > 0.2:
			make_eyebrow_curve()
		var baseColor
		if !color: 
			baseColor = Color(randf(),randf(),randf())
		else:
			baseColor = color

	#	var faceTexture = preload("res://assets/img/textures/sand_1.jpg")
		var faceTexture = null
		emit_signal("to_polygon", [topCurve, bottomCurve], baseColor.lightened(randf() * 0.4), faceTexture)
		emit_signal("to_polygon", [upperLipCurve, bottomLipCurve], baseColor.darkened(randf()))
		emit_signal("to_polygon", [upperLipCurve, mouthLineCurve], baseColor.darkened(randf()))
		emit_signal("to_polygon", [mouthLineCurve2, bottomLipCurve], baseColor.darkened(randf()))
		emit_signal("to_polygon", [eyeCurve], baseColor.contrasted().lightened(0.9))
		emit_signal("to_polygon", [pupilCurve], baseColor.darkened(randf()))
		emit_signal("to_polygon", [eyebrowCurve, eyebrowCurve2], baseColor.darkened(.5 + randf()))
		emit_signal("to_polygon", [underEyeCurve, underEyeCurve2], Color.black)
	
func make_top_curve():
	var fho = return_control_point(.5, 1.5, 0.0, 1.0)
	var mi = return_control_point(-1.0, 0.0, -1.0, 0.0)
	topCurve.add_point(foreheadPoint, Vector2.ZERO, fho * s_silhouette)
	topCurve.add_point(mouthPoint, mi * s_silhouette)
	

func make_bottom_curve():
	var mo = return_control_point(-1.0, 0.0, 0.0, 1.0)
	var ci = return_control_point(0.5, 1.0, -1.0, 0.0)
	bottomCurve.add_point(mouthPoint, Vector2.ZERO, mo * s_silhouette)
	bottomCurve.add_point(chinPoint, ci * s_silhouette * 0.5)

func make_lip_curves():
	var mco = return_control_point(0.8, 1.0, -1.8, -2.5)
	var moi = return_control_point(0.6, 1.0, -1.0, -0.5)
	upperLipCurve.add_point(mouthCornerPoint, Vector2.ZERO, mco * s_mouthScale)
	upperLipCurve.add_point(mouthOpeningPoint, moi * s_mouthScale)

	var moo = return_control_point(0.0, 1.1, 1.0, 1.5)
	bottomLipCurve.add_point(mouthOpeningPoint, Vector2.ZERO, moo * s_mouthScale)
	bottomLipCurve.add_point(mouthCornerPoint, mco * s_mouthScale * (0.1 + (randf() * 0.2)))
	
	mouthLineCurve.add_point(mouthOpeningPoint, Vector2.ZERO)
	mouthLineCurve.add_point(mouthCornerPoint, mco * s_mouthScale * 0.3)
	
	mouthLineCurve2.add_point(upperLipCurve.interpolate_baked(0.3), Vector2.ZERO, mco * s_mouthScale * 0.3)
	mouthLineCurve2.add_point(mouthOpeningPoint)


func make_eye_curve():
	var eyeScale = s_eyeSize * 0.5
	var eyeSize = s_eyeSize
	var pupilSize = eyeSize * (0.1 + randf() * .5)
	var pupilScale = pupilSize * 0.5 
	
	var p1o = return_control_point(0.5, 1.0, -0.5, 0.5)
	var p2i = return_control_point(-0.5, 0.5, -1.0, -0.5)
	var p2o = -p2i
	var p3i = return_control_point(0.5, 1.0, -0.5, 0.5)
	var p3o = -p3i
	var p4i = return_control_point(-0.5, 0.5, 0.5, 1.0)
	var p4o = -p4i
	var p5i = -p1o
	
	eyeCurve.add_point(eyePoint - Vector2(0.0,eyeSize), Vector2.ZERO, p1o * eyeScale)
	eyeCurve.add_point(eyePoint + Vector2(eyeSize,0.0), p2i * eyeScale, p2o * eyeScale)
	eyeCurve.add_point(eyePoint + Vector2(0.0,eyeSize), p3i * eyeScale, p3o * eyeScale)
	eyeCurve.add_point(eyePoint - Vector2(eyeSize,0.0), p4i * eyeScale, p4o * eyeScale)
	eyeCurve.add_point(eyePoint - Vector2(0.0,eyeSize), p5i * eyeScale)
	
	pupilCurve.add_point(eyePoint - Vector2(0.0,pupilSize), Vector2.ZERO, p1o * pupilScale)
	pupilCurve.add_point(eyePoint + Vector2(pupilSize,0.0), p2i * pupilScale, p2o * pupilScale)
	pupilCurve.add_point(eyePoint + Vector2(0.0,pupilSize), p3i * pupilScale, p3o * pupilScale)
	pupilCurve.add_point(eyePoint - Vector2(pupilSize,0.0), p4i * pupilScale, p4o * pupilScale)
	pupilCurve.add_point(eyePoint - Vector2(0.0,pupilSize), p5i * pupilScale)
	
	var uei = return_control_point(-0.2, 0.0, 0.0, 0.0)
	var ueo = -uei
	
	underEyeCurve.add_point(eyePoint + Vector2(0.0,eyeSize) + Vector2(-eyeSize * 0.75, 24.0))
	underEyeCurve.add_point(eyePoint + Vector2(0.0,eyeSize + 12.0), uei * eyeScale, ueo * eyeScale)
	underEyeCurve.add_point(eyePoint + Vector2(0.0,eyeSize) + Vector2(eyeSize * 0.75, 24.0))
	
	underEyeCurve2.add_point(eyePoint + Vector2(0.0, 2.0) + Vector2(0.0,eyeSize) + Vector2(eyeSize * 0.75, 24.0))
	underEyeCurve2.add_point(eyePoint + Vector2(0.0, 2.0) + Vector2(0.0,eyeSize + 12.0), ueo * eyeScale, uei * eyeScale)
	underEyeCurve2.add_point(eyePoint + Vector2(0.0, 2.0) + Vector2(0.0,eyeSize) + Vector2(-eyeSize * 0.75, 24.0))
	
func make_eyebrow_curve():
	var eyebrowScale = 60.0
	var eyebrowThickness = 12.0 + randf() * 32.0
	var p1o = return_control_point(0.5, 1.0, -0.5, 0.5)
	var p2i = return_control_point(-0.5, 0.0, -0.5, 0.5)
	eyebrowCurve.add_point(eyebrowStartPoint, Vector2.ZERO, p1o * eyebrowScale)
	eyebrowCurve.add_point(eyebrowEndPoint, p2i * eyebrowScale)
	
	eyebrowCurve2.add_point(eyebrowEndPoint+ Vector2(0.0, eyebrowThickness * randf()), Vector2.ZERO, p2i * eyebrowScale)
	eyebrowCurve2.add_point(eyebrowStartPoint + Vector2(0.0, eyebrowThickness * randf()), p1o * eyebrowScale)
	
func return_control_point(xmin, xmax, ymin, ymax):
	var x = rand_range(xmin, xmax)
	var y = rand_range(ymin, ymax)
	return Vector2(x,y).normalized()
