extends Resource
class_name CellAddition

var location : Vector3 #normalized vector, denoting location on cell this addition must be placed.
var additionScene : PackedScene #this will be filled by cellularAddition during generation
var islandSave

func get_scene(): 
	return additionScene
