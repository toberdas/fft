extends CellAddition
class_name TreasureResource

export(Resource) var key = preload("res://assets/resources/items/specificItems/KEYS/BlueKey.tres")
export(Resource) var lootItem = preload("res://assets/resources/items/specificItems/rods/BeginnersRod.tres")

var treasureIsFound = false
var treasureUnearthed = false

var triggerResourceArray = [] setget set_triggers

signal treasure_found
signal treasure_unearthed

func treasure_is_found():
	treasureIsFound = true
	emit_signal("treasure_found")

func initialize_instance(treasureNode):
	treasureNode.treasureResource = self
	return treasureNode

func set_triggers(triggerArray):
	triggerResourceArray = triggerArray
	for triggerResource in triggerResourceArray:
		triggerResource.connect("triggered", self, "check_triggers")

func check_triggers():
	for triggerResource in triggerResourceArray:
		if !triggerResource.triggered:
			return false
	unearth()

func unearth():
	treasureUnearthed = true
	emit_signal("treasure_unearthed")

func treasure_looted():
	if islandSave:
		islandSave.treasure_looted()
