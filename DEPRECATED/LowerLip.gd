extends FaceElement

func generate_curve():
	var bottomLipCurve = Curve2D.new()
	var mouthLineCurve2 = Curve2D.new()
	
	var mouthCornerPoint = vardic["mouthCornerPoint"]
	var mouthOpeningPoint = vardic["mouthOpeningPoint"]
	var mouthScale = vardic["mouthScale"]
	var mouthCornerOut = vardic["mouthCornerOut"]
	var upperLipCurve = vardic["upperLipCurve"]
	
	var moo = return_control_point(0.0, 1.1, 1.0, 1.5)
	bottomLipCurve.add_point(mouthOpeningPoint, Vector2.ZERO, moo * mouthScale)
	bottomLipCurve.add_point(mouthCornerPoint, mouthCornerOut * mouthScale * (0.1 + (randf() * 0.2)))
	
	mouthLineCurve2.add_point(upperLipCurve.interpolate_baked(1.0 - 0.3), Vector2.ZERO, mouthCornerOut * mouthScale * 0.3)
	mouthLineCurve2.add_point(mouthOpeningPoint)
	
	curves = [mouthLineCurve2, bottomLipCurve]
