extends Spatial

var platformArray = []

export(PackedScene) var fishScene
export(PackedScene) var platScene ##OOK PROCGEN UITEINDELIJK

func _on_IslandNode_start_initialize(res, _play):
	pass
#	res.platformWalk.connect("point_added", self, "add_platform")
#	res.platformWalk.connect("branch_end", self, "add_goodie")
#	res.platformWalk.run()

func add_platform(point):
	var p = platScene.instance()
	add_child(p)
	p.global_transform.origin = global_transform.origin + point.islandSpacePosition
	p.scale.x = 1.0 + randf()
	p.scale.z = 1.0 + randf()
	p.scale.y = 1.0 + randf()
	p.translate(transform.origin)
	platformArray.append(p)

func add_goodie(point):
	var f = fishScene.instance()
	add_child(f)
	f.global_transform.origin = global_transform.origin + point.islandSpacePosition + Vector3(0.0,2.0,0.0)
	f.translate(transform.origin)
#	f.global_transform.origin.y += 20.0
	pass
