extends Node


export(Resource) var equipResource


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Equip.equipResource = equipResource
	$Equip.open_and_add_item_nodes()
