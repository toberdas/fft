extends Path

func create_curvy_path(pointarray, targetcurve):
	var castcurve = Curve3D.new() #make a new curve to add to the castpath later
	var i = 0
	for point in pointarray:
		var tci = Vector3.ZERO
		var tco = Vector3.ZERO
		if targetcurve:
			if i < targetcurve.get_point_count():
				tci = targetcurve.get_point_in(i)
				tco = targetcurve.get_point_out(i)
#		castcurve.add_point(to_local(point),tci, tco) #iterate through points in scaledarray and add them as control points in curve, with in and out
		castcurve.add_point(point,tci, tco)
		i += 1
	return castcurve
