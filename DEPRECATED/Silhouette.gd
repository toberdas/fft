extends FaceElement

func generate_curve():
	var foreheadPoint = vardic["foreheadPoint"]
	var mouthPoint = vardic["mouthPoint"]
	var chinPoint = vardic["chinPoint"]
	var silhouetteScale = vardic["silhouetteScale"]
	
	var topCurve = Curve2D.new()
	var bottomCurve = Curve2D.new()
	
	var fho = return_control_point(.5, 1.5, 0.0, 1.0)
	var mi = return_control_point(-1.0, 0.0, -1.0, 0.0)
	topCurve.add_point(foreheadPoint, Vector2.ZERO, fho * silhouetteScale)
	topCurve.add_point(mouthPoint, mi * silhouetteScale)
	
	var mo = return_control_point(-1.0, 0.0, 0.0, 1.0)
	var ci = return_control_point(0.5, 1.0, -1.0, 0.0)
	bottomCurve.add_point(mouthPoint, Vector2.ZERO, mo * silhouetteScale)
	bottomCurve.add_point(chinPoint, ci * silhouetteScale * 0.5)
	curves = [topCurve, bottomCurve]
