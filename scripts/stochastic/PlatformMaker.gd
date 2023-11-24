extends Spatial

export(PackedScene) var platform

func clear():
	for child in get_children():
		child.queue_free()

func add_platforms_from_cells(ar, depth):
	for cell in ar:
		var plat = platform.instance()
		plat.transform.origin = cell.location * 1 - Vector3(depth * 0.5, 0.0, depth * 0.5)
		add_child(plat)
