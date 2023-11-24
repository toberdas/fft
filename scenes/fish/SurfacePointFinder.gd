extends Spatial
class_name SurfacePointFinder

#func _init(surface):
#	return find_point_on_surface(surface)

func find_point_on_surface(surface):
	if surface:
		var t = surface.transform
		var x = rand_range(-1.0, 1.0)
		var y = rand_range(-1.0, 1.0)
		var p = Vector3.ZERO
		p = t.origin + t.basis.y * 0.5
		p += t.basis.x * 0.5 * x
		p += t.basis.z * 0.5 * y
		return p
	return null
