#base resource for loot tables, add a specific loot table to an interactable, or add this resource and tailor make it, dont forget to set it to unique to scene in that case
extends Resource
class_name LootTable

export(Resource) var guaranteedItem
export(String, "everyday", "strange", "unique", "artifact", "stellar") var guaranteedRarity = ""
export(Array, Resource) var itemList
export(int) var amount = 1

var rarityDict = {
	"everyday" : .8, 
	"strange" : .4, 
	"unique" : .1, 
	"artifact" : .05, 
	"stellar" : .01
}

func fill_table():
	var lootTable = []
	for _i in amount:
		for item in itemList:
			if roll_rarity(item.rarity):
				lootTable.append(item)
	if guaranteedItem:
		lootTable.append(guaranteedItem)
	return lootTable

func roll_rarity(rarity):
	var r = randf()
	if r < rarityDict[rarity] or rarity == guaranteedRarity:
		return true
	return false
