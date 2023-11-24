extends Node2D

func clear():
	for child in get_children():
		child.queue_free()

func make_polygon(curves, color, texture = null):
	var par = []
#	var poolColorArray = PoolColorArray()
	for curve in curves:
		var cp = curve.get_baked_points()
		for p in cp:
			par.append(p)
#			poolColorArray.append(color)
	var pva = PoolVector2Array(par)
	var pol = Polygon2D.new()
	pol.polygon = pva
	pol.use_parent_material = true
	pol.color = color
	if texture:
		pol.texture = texture
	pol.antialiased = true
	add_child(pol)

func _on_CurveGenerator_to_polygon(curves, color, texture = null):
	make_polygon(curves, color, texture)
