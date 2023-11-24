extends Spatial


func get_cam_dot(reelinFish):
	var cam = GlobalSingleton.cam
	if reelinFish:
		var fdir = cam.global_transform.origin - reelinFish.global_transform.origin
		fdir = fdir.normalized()
		return cam.global_transform.basis.z.dot(fdir)
	else:
		return 0.0

func get_fish_dot(reelinFish):
	if reelinFish:
		var dir = reelinFish.global_transform.origin - global_transform.origin
		dir = dir.normalized()
		return reelinFish.global_transform.basis.z.dot(dir)
	else:
		return 0.0
