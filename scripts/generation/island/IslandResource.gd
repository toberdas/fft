extends Resource
class_name IslandResource

var loadDistance = GameplayConstants.islandLoadDistance

signal resource_loaded

##NEW
const cellularAdditionDefinitionList = preload("res://assets/resources/cellularadditions/CellularAdditionDefinitionList.tres")
var cellularAdditionGenerationStep = 0

var islandSave setget set_island_save
var islandCharacter
var islandCellular

var topcells
var islandSeed = 0
var tier = 0

var generationStep = 0
var point : Vector2

var generationFunctions = [
	"generate_character",
	"generate_island_cellular",
	"generate_cellular_additions"
	]

func generate_at_once():
	while !generation_step():
		pass

func generate_character():
	islandCharacter = IslandCharacter.new(tier, self)
	return true

func generate_island_cellular():
	if !islandCellular:
		islandCellular = IslandCellular.new(islandCharacter, true)
		return false
	else:
		if islandCellular.generate_step():
			if islandCellular.liveCells.size() < 12:
				print_debug("Dead island, making new resource")
				islandSeed = islandSeed - 1
				generationStep = 0
				islandCellular = null
				return false
			else:
				return true
	
func generation_step():
	seed(islandSeed)
	var done = call(generationFunctions[generationStep])
	if done:
		generationStep += 1
	if generationStep == generationFunctions.size():
		return true
		generationStep = 0
	else:
		return false

func generate_cellular_additions():
	var additionDefinition = cellularAdditionDefinitionList.get(cellularAdditionGenerationStep)
	if additionDefinition:
		seed(islandSeed)
		var generatingObject = additionDefinition.get_object().new()
		generatingObject.cellular = islandCellular
		generatingObject.islandSave = islandSave
		generatingObject.cellAdditionScene = additionDefinition.cellAdditionScene
		generatingObject.name = additionDefinition.className
		generatingObject.call("generate")
		cellularAdditionGenerationStep += 1
		return false
	else:
		cellularAdditionGenerationStep = 0
		return true

func get_surface_of_cell(cell):
	return get_surface_location(cell.location)

func get_surface_location(location):
	return location * islandCharacter.scale + Vector3(0,islandCharacter.scale * 0.50, 0)

func get_real_surfaces():
	var rv = []
	if islandCellular.topCells:
		for cell in islandCellular.topCells:
			rv.append(get_surface_of_cell(cell))
	return rv

func set_island_save(_islandSave):
	islandSave = _islandSave
	tier = _islandSave.tier
	point = _islandSave.point
	islandSeed = _islandSave.islandSeed
