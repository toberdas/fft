extends Spatial
class_name CellAdditionScene

var cellAddition

func _ready():
	if cellAddition:
		load_addition()
	load_anything()
		
func load_addition(): #OVERRIDE
	pass

func load_anything(): #OVERRIDE
	pass
