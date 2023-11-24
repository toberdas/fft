extends Spatial

export(PackedScene) var rockScene
export(PackedScene) var rockSceneStraight
export(PackedScene) var meshPath
export(PackedScene) var beachScene
export(PackedScene) var placeHOLDERDOODAD
var islandPhysical = null
var islandResource = null
var loading = false

func dict_step():
	for key in islandPhysical.toInstance.keys():
		load_step(0, key)

func load_step(i, key):
	if i < islandPhysical.toInstance[key].size():
		var inst = islandPhysical.toInstance[key][i]
		if key == 'cliffs':
			var ri = rockSceneStraight.instance()
			add_child(ri)
			ri.transform = inst.transform
			set_material_params(ri, inst)
		if key == 'surfaces':
			var ri = rockSceneStraight.instance()
			add_child(ri)
			ri.transform = inst.transform
			set_material_params(ri, inst)
		if key == 'beach':
			var bi = beachScene.instance()
			bi.mesh = inst.mesh
			bi.transform.origin = Vector3(islandPhysical.seedPoint.x, 20.0, islandPhysical.seedPoint.y)
			bi.scale = Vector3(islandResource.islandCharacter.scale * 3.0,islandResource.islandCharacter.height * 0.1,islandResource.islandCharacter.scale * 3.0)
			bi.get_child(0).get_child(0).shape = inst.colShape
			add_child(bi)
		if key == 'doodads':
			var di = placeHOLDERDOODAD.instance()
			di.transform = inst.transform
			add_child(di)
		if key == 'platforms':
			var pi = rockSceneStraight.instance()
			pi.transform = inst.transform
			add_child(pi)
			set_material_params(pi, inst)
		i += 1
		yield(get_tree().create_timer(0.1), "timeout")
		load_step(i, key)
	else:
		loading = false

func add_rock_childs():
	pass
#	for key in islandPhysical.rockDict:
#		var ri = rockScene.instance()
#		add_child(ri)
#		ri.transform = islandPhysical.rockDict[key].transform
#		set_material_params(ri, key)
#
#		for s in islandPhysical.rockDict[key].surface.surfaces:
#			var pi = rockScene.instance()
#			add_child(pi)
#			pi.transform = s.transform
#			set_material_params(pi, key)
#			var ps = s.point
#			if ps:
#				var pis = rockScene.instance()
#				add_child(pis)
#				pis.transform = ps.transform
#		for con in islandPhysical.connections:
#			var p = meshPath.instance()
#			add_child(p)
#			p.curve.add_point(con.startRock.transform.origin)
#			p.curve.add_point(con.targetRock.transform.origin)
#			p.run()
#
#	var bi = beachScene.instance()
#	bi.mesh = islandPhysical.beach.mesh
#	bi.transform.origin = Vector3(islandPhysical.seedPoint.x, 0.0, islandPhysical.seedPoint.y)
#	bi.scale = Vector3(300.0,5.0,300.0)
#	bi.get_child(0).get_child(0).shape = islandPhysical.beach.colShape
#	add_child(bi)

func set_material_params(meshinst, _el):
#	var meshscale = meshinst.transform.basis.get_scale()
	meshinst.get_node('MeshInstance').get_active_material(0).uv1_scale = Vector3.ONE + meshinst.transform.basis.get_scale() * 0.02
	meshinst.get_node('MeshInstance').get_active_material(0).distance_fade_min_distance = int(GameplayConstants.islandLoadDistance - 100)
	meshinst.get_node('MeshInstance').get_active_material(0).distance_fade_min_distance = int(GameplayConstants.islandLoadDistance - 400)
#	meshinst.get_node("MeshInstance").get_surface_material(0).albedo_color = Color.antiquewhite.darkened(el.weight)

func start_load():
	if loading == false:
		loading = true
		dict_step()
	
func _on_IslandNode_start_initialize(res, _player):
	islandResource = res
	islandPhysical = res.physical
	start_load()
