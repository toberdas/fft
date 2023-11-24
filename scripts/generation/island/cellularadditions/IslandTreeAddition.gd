extends CellularAddition
class_name IslandTreeAddition

var treeData
var treeArray = []
var scale 
var treeChance 
var maxTrees = 10
var texture : Texture

const textureCollection = preload("res://assets/resources/island/AllTreeTextures.tres")

func generate():
	treeChance = rand_range(0.2,0.4)
	var topCell = cellular.find_highest_cell()
	texture = textureCollection.get_random_item()
	treeData = IslandTreeData.new()
	var noise = OpenSimplexNoise.new()
	var count = 0
	var cellCount = cellular.topCells.size()
	for i in range(cellCount):
		if treeChance > randf():
			if count < maxTrees:
				var unitLocation = get_unit_location(noise)
				var depthLocation = unitLocation * cellular.depth
				var cellOnLocation = test_surface_dict(cellular, depthLocation)
				if cellOnLocation:
					var finalLocation = Vector3.ZERO
					var t = IslandTree.new()
					t.location = finalLocation
					t.data = treeData
					t.generate()
					put_data_in_cell(t, cellOnLocation)
					treeArray.append(t)
					count += 1

func get_unit_location(_noise : OpenSimplexNoise):
	var try = HelperScripts.random_vec2()
	var n = 0
	while _noise.get_noise_2dv(try) < .6 && n < 10:
		try = HelperScripts.random_vec2()
		n+=1
	return try

func test_surface_dict(cellular, location : Vector2):
	var flooredVec = location.ceil()
	if cellular.surfaceDict.has(flooredVec):
		return cellular.surfaceDict[flooredVec]
