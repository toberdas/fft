extends FaceElement

func generate_curve():
	var upperLipCurve = Curve2D.new()
	var mouthLineCurve = Curve2D.new()
	
	var mouthCornerPoint = vardic["mouthCornerPoint"]
	var mouthOpeningPoint = vardic["mouthOpeningPoint"]
	var mouthScale = vardic["mouthScale"]
	var mouthCornerOut = vardic["mouthCornerOut"] 
	
	var mco = return_control_point(0.8, 1.0, -1.8, -2.5)
	mco = mouthCornerOut
	var moi = return_control_point(0.6, 1.0, -1.0, -0.5)
	upperLipCurve.add_point(mouthCornerPoint, Vector2.ZERO, mco * mouthScale)
	upperLipCurve.add_point(mouthOpeningPoint, moi * mouthScale)
	mouthLineCurve.add_point(mouthOpeningPoint, Vector2.ZERO)
	mouthLineCurve.add_point(mouthCornerPoint, mco * mouthScale * 0.3)
	
	curves = [upperLipCurve, mouthLineCurve]
