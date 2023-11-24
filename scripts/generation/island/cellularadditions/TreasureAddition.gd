extends CellularAddition
class_name TreasureAddition

func generate():
	if !islandSave.treasureLooted:
		var triggers = cellular.additionDict["Triggers"]
		var topCell = cellular.find_highest_cell()
		var treasureResource = TreasureResource.new()
		treasureResource.location = Vector3.ZERO
		treasureResource.key = HelperScripts.random_value_from_array(ItemData.keys)
		treasureResource.lootItem = HelperScripts.random_value_from_array(ItemData.lootItems)
		treasureResource.triggerResourceArray = triggers
		put_data_in_cell(treasureResource, topCell)
