extends Resource
class_name CellularAdditionDefinition

export(PackedScene) var cellAdditionScene
export(String, 'Trees', 'Triggers', 'Treasure') var className 

var classDict = {
	'Trees' : IslandTreeAddition,
	'Triggers' : TriggerAddition,
	'Treasure' : TreasureAddition
}

func get_object():
	return classDict[className]
