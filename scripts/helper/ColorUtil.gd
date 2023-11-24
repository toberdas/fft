class_name ColorUtil

static func move_toward_color(colorA : Color, colorB : Color, delta):
	colorA.r = move_toward(colorA.r, colorB.r, delta)
	colorA.g = move_toward(colorA.g, colorB.g, delta)
	colorA.b = move_toward(colorA.b, colorB.b, delta)
	return colorA

static func get_biggest_difference(colorA : Color, colorB : Color):
	var rDif = abs(colorA.r - colorB.r)
	var gDif = abs(colorA.g - colorB.g)
	var bDif = abs(colorA.b - colorB.b)
	return max(rDif,max(gDif,bDif))
