extends Resource
class_name CellularAutomata3D

var gridDict = {}
var checkingCells = []
var liveCells = [] setget ,get_live_cells
var myDepth = 0
var myHeight = 0
var rule : CellularRule = null
var initialized = false

signal generation_done

func _init(depth, height, stoch = true, _rule = null):
	myDepth = depth
	myHeight = height
	if _rule == null:
		rule = CellularRule.new(CellularRule.presets.builder, stoch)
	else:
		rule = _rule
	create_grid(depth, height)

func create_grid(depth, height):
	for x in depth:
		for y in height:
			for z in depth:
				gridDict[Vector3(x,y,z)] = Cell.new(Vector3(x,y,z))
				gridDict[Vector3(x,y,z)].connect("cell_death", self, "on_cell_death")
				gridDict[Vector3(x,y,z)].connect("cell_birth", self, "on_cell_birth")
				var _ce = connect("generation_done", gridDict[Vector3(x,y,z)], "update_state")

func fill_from_array(array):
	for i in array:
		if i is Vector3:
			if is_position_within_grid(i):
				gridDict[i].revive(rule.states)

func get_check_cells():
	var checkCells = {}
	for cell in liveCells:
		var newCheckCells = get_neighbouring_cells_simple(cell.location, rule.neighbourhood)
		for newCheckCell in newCheckCells:
			checkCells[newCheckCell.location] = newCheckCell
	return checkCells.values()

func set_first_life_count():
	var checkCells = get_check_cells()
	for cc in checkCells:
		var lifeCount = check_neighbouring(cc.location)
		cc.lifeCount = lifeCount

func generation():
	var checkCells = get_check_cells()
	for cc in checkCells:
		if cc.cellState == Cell.state.alive:
			if !rule.check_alive(cc.lifeCount):
				cc.start_dying(rule.states)
		if cc.cellState == Cell.state.dead: 
			if rule.check_revive(cc.lifeCount):
				cc.revive(rule.states)
		if cc.cellState == Cell.state.dying:
			cc.detoriate()
	emit_signal("generation_done")

#func generation():
#	var checkCells = get_check_cells()
#	for cc in checkCells:
#		if cc.cellState == Cell.state.alive:
#			var count = check_neighbouring(cc.location)
#			if !rule.check_alive(count):
#				cc.start_dying(rule.states)
#		if cc.cellState == Cell.state.dead: 
#			var count = check_neighbouring(cc.location)
#			if rule.check_revive(count):
#				cc.revive(rule.states)
#		if cc.cellState == Cell.state.dying:
#			cc.detoriate()
#	emit_signal("generation_done")

func check_neighbouring(loc = Vector3()):
	var lifeCount = 0
	for dir in rule.neighbourhood.checkList:
		var c = loc + dir
		if is_position_within_grid(c):
			if is_cell_alive(c) or is_cell_dying(c):
				if c != loc:
					lifeCount += 1
	return lifeCount

func on_cell_death(cell):
	var neighbours = get_neighbouring_cells(cell.location, rule.neighbourhood)
	for neighbour in neighbours:
		neighbour.lifeCount -= 1
	liveCells.erase(cell)

func on_cell_birth(cell):
	var neighbours = get_neighbouring_cells(cell.location, rule.neighbourhood)
	for neighbour in neighbours:
		neighbour.lifeCount += 1
	liveCells.append(cell)

func get_live_cells():
	return liveCells

func is_position_within_grid(location : Vector3):
	return location.x > 0 && location.x < myDepth && location.y > 0 && location.y < myHeight && location.z > 0 && location.z < myDepth

func is_cell_alive(location : Vector3):
	return gridDict[location].cellState == Cell.state.alive
	
func is_cell_dying(location : Vector3):
	return gridDict[location].cellState == Cell.state.dying

func is_cell_dead(location : Vector3):
	return gridDict[location].cellState == Cell.state.dead

func get_neighbouring_cells(loc : Vector3, neighbourhood : Neighbourhood, allowedStates : Array = []):
	var neighbours = []
	for dir in neighbourhood.checkList:
		var newPos = loc + dir
		if is_position_within_grid(newPos):
			var newCell = gridDict[newPos]
			if allowedStates.size() > 0:
				if allowedStates.has(newCell.cellState):
					 neighbours.append(newCell)
			else:
				neighbours.append(newCell)
	return neighbours

func get_neighbouring_cells_simple(loc : Vector3, neighbourhood : Neighbourhood):
	var neighbours = []
	for dir in neighbourhood.checkList:
		var newPos = loc + dir
		if is_position_within_grid(newPos):
			var newCell = gridDict[newPos]
			neighbours.append(newCell)
	return neighbours
