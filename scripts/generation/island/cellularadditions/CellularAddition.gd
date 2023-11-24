extends Resource
class_name CellularAddition

var islandSave
var cellular : IslandCellular
var cellAdditionScene : PackedScene
var name : String
	
func generate(): ##OVERRIDE
	pass

func put_data_in_cell(data : CellAddition, cell : Cell):
	if cell && data:
		data.additionScene = cellAdditionScene
		data.islandSave = islandSave
		cell.cellAdditions.entityData = data
		cellular.put_in_dict_at_name(data, name)

