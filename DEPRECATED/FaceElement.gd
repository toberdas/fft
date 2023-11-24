extends Node
class_name FaceElement
#Framework for facial elements

var polygon = null
var curves = []
var color = Color(randf(),randf(),randf())
var vardic = null

func run(_vardic = {}):
	vardic = _vardic
	generate_curve()
	curve_to_polygon()	

func generate_curve(): #TO OVERRIDE
	pass

func curve_to_polygon():
	if polygon:
		polygon.queue_free()
	polygon = CurvePolygon.new(curves, color)
	add_child(polygon)

func return_control_point(xmin, xmax, ymin, ymax):
	var x = rand_range(xmin, xmax)
	var y = rand_range(ymin, ymax)
	return Vector2(x,y).normalized()
