extends Polygon2D
class_name CurvePolygon

signal polygon_ready

func _init(curves, color = Color(randf(),randf(),randf())):
	make_polygon(curves, color)

func clear():
	for child in get_children():
		child.queue_free()

func make_polygon(curves, _color):
	var par = []
	for curve in curves:
		var cp = curve.get_baked_points()
		for p in cp:
			par.append(p)
	var pva = PoolVector2Array(par)
	polygon = pva
	color = _color
	antialiased = true
	emit_signal("polygon_ready")
