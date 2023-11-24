extends Spatial

const treeNode = preload("res://scenes/environment/TreeNode.tscn")
const chestScene = preload("res://scenes/interacts/specific/Chest.tscn")

var cachedLoaders = {}

func load_cell_additions(cell, cube):
	var data :CellAddition= cell.cellAdditions.entityData
	if !data:
		return
	var instance : CellAdditionScene= data.get_scene().instance()
	instance.cellAddition = data
	cube.add_child(instance)
	instance.transform.origin = data.location
	return instance
