extends Spatial

func grow_on_bush(item):
	var spawnPoint = HelperScripts.random_value_from_array($FruitPoints.get_children())
	add_child(item)
	item.transform.basis = Basis(Vector3.ONE)
#	item.global_transform.origin = spawnPoint.global_transform.origin
