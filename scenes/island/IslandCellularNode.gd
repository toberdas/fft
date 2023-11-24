extends Spatial


var islandCellular = null
export(PackedScene) var cube
export(PackedScene) var colcube
export(NoiseTexture) var noise
var sc = 6

signal generation_done
signal cube_added

var cubeArray = []

var loadingTopCubes = false
var loadingRest = false
var cubeIndex = 0

func _on_IslandNode_start_initialize(save : IslandSave):
	start_load(save)

func start_load(save:IslandSave):
	islandCellular = save.islandResource.islandCellular
	sc = save.islandResource.islandCharacter.scale
	loadingTopCubes = true
	for cell in islandCellular.baseCells:
		for i in range(5):
			var cube = make_cube(cell)
			cube.transform.origin.y -= i * sc

func _process(delta):
	if loadingTopCubes:
		for i in range(5):
			var cell = islandCellular.topCells[cubeIndex]
			var cube = make_cube(cell)
			var node = $CellAdditionSplitter.load_cell_additions(cell, cube)
			if node: 
				node.transform.basis = node.transform.basis.scaled(Vector3(1.0/sc,1.0/sc,1.0/sc))
				node.global_transform.origin.y += sc * 0.5
			cubeIndex += 1
			if cubeIndex == islandCellular.topCells.size():
				loadingTopCubes = false
				loadingRest = true
				cubeIndex = 0
				break
	if loadingRest:
		if islandCellular.bottomCells.size() == 0:
			loadingRest = false
			emit_signal("generation_done")
			return
		for i in range(5):
			var cell = islandCellular.bottomCells[cubeIndex]
			var cube = make_cube(cell)
			var node = $CellAdditionSplitter.load_cell_additions(cell, cube)
			if node: 
				node.transform.basis = node.transform.basis.scaled(Vector3(1.0/sc,1.0/sc,1.0/sc))
				node.global_transform.origin.y += sc * 0.5
			cubeIndex += 1
			if cubeIndex == islandCellular.bottomCells.size():
				loadingRest = false
				cubeIndex = 0
				emit_signal("generation_done")
#				$MeshInstance.merge_meshes_custom(0)
				break

func make_cube(cell:Cell):
	var c = cube.instance()
	c.transform.basis = c.transform.basis.scaled(Vector3(sc,sc,sc))
	c.transform.origin = cell.location * sc
	recalculate_top(c.transform.origin.y)
	color_cube(c, cell)
	$MeshInstance.add_child(c)
#	c.global_transform.origin += Vector3.ONE * noise.noise.get_noise_3dv(c.global_transform.origin) * 2.0
	emit_signal("cube_added", c)
	cubeArray.append(c)
	return c

func recalculate_top(newY):
	if newY > $HighestPoint.transform.origin.y:
		$HighestPoint.transform.origin.y = newY

func color_cube(c, cell : Cell):
	var heightratio = cell.location.y / islandCellular.height
	var birthratio = cell.birthCounter / islandCellular.generations
	var stateratio = cell.stateCounter / islandCellular.rule.states
	var mat = c.get_active_material(0) 
	var noiseVal = noise.noise.get_noise_3dv(cell.location * sc) * 1.0
#	mat.uv1_offset.x = noiseVal * 4.5
##	mat.uv1_scale += Vector3(noiseVal,noiseVal,noiseVal) * 0.08
#	mat.albedo_texture = islandCellular.texture
#	mat.albedo_color = mat.albedo_color.lightened(heightratio)
#	mat.albedo_color = mat.albedo_color.darkened(birthratio)
#	mat.albedo_color = mat.albedo_color.darkened(stateratio * 0.3)
#	mat.distance_fade_min_distance = GameplayConstants.islandLoadDistance - 300
#	mat.distance_fade_max_distance = GameplayConstants.islandLoadDistance - 600
