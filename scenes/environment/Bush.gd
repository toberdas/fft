extends Spatial

func grow_on_bush(item):
	var spawnPoint = HelperScripts.random_value_from_array($FruitPoints.get_children())
	spawnPoint.add_child(item)
#	item.global_transform.origin = spawnPoint.global_transform.origin
