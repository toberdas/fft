extends Resource
class_name IslandCellular

var rocklist
var cellular
var generations = 0
var generationStep = 0
var scale = 6
var height
var depth
var amount
var rule = null
var liveCells = []
var topCells = []
var bottomCells = []
var surfaceCells = []
var triggerCells = []
var insideCells = []
var baseCells = []
var surfaceDict = {}
var additionDict = {}
var aStar : AStar
var texture : Texture
var aStarFilled = false

const textureCollection = preload("res://assets/resources/island/AllRockTextures.tres")

signal automata_done

func _init(character : IslandCharacter, stoch = true):
	var tier = character.tier
	scale = character.scale
	
	depth = character.cellularDepth
	height = character.cellularHeight
	amount = character.cellularAmount
	 
	rocklist = RockList.new(depth, height, amount)
	rule = CellularRule.new(character.cellularRule, stoch)
	cellular = CellularAutomata3D.new(depth, height, stoch, rule)
	cellular.fill_from_array(rocklist.rockList)
	cellular.set_first_life_count()
	generations = character.cellularGenerations
	
	aStar = AStar.new()
	texture = textureCollection.get_random_item()
#	cellular = free_cellular(cellular)

func generate_step():
	if generationStep <= generations:
		cellular.generation()
		generationStep += 1
		print('generation step')
		return false
	else:
		if !aStarFilled:
			aStarFilled = true
			fill_a_star()
			return false
		else:
			liveCells = cellular.liveCells
			topCells = find_cellular_topcells(cellular)
			bottomCells = find_bottomcells()
			insideCells = find_inside_cells()
			surfaceCells = find_cellular_surface_cells()
			surfaceDict = find_cellular_surface_cells_by_xy()
			baseCells = find_base_cells()
			return true
	

func generate():
	for _i in range(generations):
		cellular.generation()
	liveCells = cellular.liveCells
	topCells = find_cellular_topcells(cellular)
	bottomCells = find_bottomcells()
	surfaceCells = find_cellular_surface_cells()
	surfaceDict = find_cellular_surface_cells_by_xy()
	fill_a_star()
	emit_signal("automata_done")
	
func fill_a_star():

	var checkCells = cellular.get_check_cells()
	for i in range(checkCells.size()):
		var cell = checkCells[i]
		if cell.cellState == Cell.state.dead:
			aStar.add_point(i, cell.location)
			i += 1
	var neighbourhood = Neighbourhood.new(Neighbourhood.style.Neumann)
	for point in aStar.get_points():
		var position = aStar.get_point_position(point)
		var neighbouringDeadCells = cellular.get_neighbouring_cells(position, neighbourhood, [Cell.state.dead])
		for deadCell in neighbouringDeadCells:
			var fromPoint = aStar.get_closest_point(position)
			var toPoint = aStar.get_closest_point(deadCell.location)
			if fromPoint != toPoint:
				aStar.connect_points(fromPoint, toPoint)

func get_point_path(loc1, loc2):
	var point1 = aStar.get_closest_point(loc1)
	var point2 = aStar.get_closest_point(loc2)
	var path = aStar.get_point_path(point1,point2)
	return path
	
func find_cellular_topcells(_cellular):
	var lf = IslandLocationPicker.new()
	return lf.find_top_cells(_cellular)

func find_bottomcells():
	var lf = IslandLocationPicker.new()
	return lf.find_bottom_cells(cellular)

func find_cellular_surface_cells():
	if cellular:
		var lf = IslandLocationPicker.new()
		return lf.find_surface_cells(cellular)

func find_cellular_surface_cells_by_xy():
	if cellular:
		var lf = IslandLocationPicker.new()
		return lf.find_surface_cells_by_xy(cellular)

func find_highest_cell():
	if cellular:
		var lf = IslandLocationPicker.new()
		return lf.find_highest_cell(cellular)
	pass

func find_nearest_cell(location : Vector3):
	if cellular:
		var lf = IslandLocationPicker.new()
		return lf.find_nearest_cell(location, cellular)
	pass

func find_inside_cells():
	if cellular:
		var lf = IslandLocationPicker.new()
		return lf.find_inside_cells(cellular)
	pass

func find_base_cells():
	if cellular:
		var lf = IslandLocationPicker.new()
		return lf.find_base_cells(cellular)
	pass

func put_in_dict_at_name(data, name):
	if additionDict.has(name):
		additionDict[name].append(data)
	else:
		additionDict[name] = [data]

func clear_addition(name):
	if additionDict.has(name):
		var list = additionDict[name]
		for cellAddition in list:
			cellAddition.free()
