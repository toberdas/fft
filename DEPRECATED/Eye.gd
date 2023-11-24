extends FaceElement


func generate_curves(color):
	var eyePoint = vardic["eyePoint"]
	var eyeSize = vardic["eyeSize"]
	var eyeScale = vardic["eyeScale"]
	var eyeCurve = Curve2D.new()
	
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
	
	curves = [eyeCurve]
