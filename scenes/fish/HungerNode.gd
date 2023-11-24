extends Node

var hunger = 0.0
var hungerCutOff = 4.0
var satiation = 3.0

func _process(delta):
	hunger += delta * randf()

func wants_to_eat(foodBody):
	var itemNode = foodBody.owner
	var tasteArray = itemNode.itemResource.get_taste_array()
	var rv = false
	if hunger > hungerCutOff:
		rv = true
	return rv


func _on_FishAttackNode_food_eaten(foodBody):
	hunger -= satiation
