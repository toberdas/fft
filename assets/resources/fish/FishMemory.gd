extends Resource
class_name FishMemory

var memories = []
var brain
var maxMemory = 10

func _init(_brain):
	brain = _brain
	maxMemory += randi() % 4

func remember():
	pass
