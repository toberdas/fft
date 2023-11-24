extends Object
class_name Key

var color : Color

func create_from_fragments(fragmentArray):
	var sideArray = []
	for fragment in fragmentArray:
		sideArray.append(fragment.side)
		if !check_side_array(sideArray):
			return false
		color = color.linear_interpolate(fragment.color, 0.5)
	pass

func check_side_array(sideArray):
	var rv = false
	if sideArray.has(Fragment.SIDES.LEFT) && sideArray.has(Fragment.SIDES.RIGHT) && sideArray.has(Fragment.SIDES.TOP):
		rv = true
	return rv
		
