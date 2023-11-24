extends Spatial

export(PackedScene) var islandInst

func run():
	for child in get_children():
		child.queue_free()
	var isl = islandInst.instance()
	add_child(isl)
	var islandResource = IslandResource.new(randi() % 6)
	isl.init(HelperScripts.random_vec2(), islandResource)
