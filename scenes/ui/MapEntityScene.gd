extends Node2D

const islandIcon = preload("res://assets/img/icons/islandIcon.png")
const fishIcon = preload("res://assets/img/icons/fishy.png")
const flockIcon = preload("res://assets/img/icons/flock.png")
const fishIslandIcon = preload("res://assets/img/icons/fishIsland.png")
var mapEntitySave

func _ready():
	if !mapEntitySave:
		return
	if mapEntitySave is IslandSave:
		$Sprite.texture = islandIcon
		$UIFocusable.nameString = str(mapEntitySave.islandSeed)
		var toolTipString = ""
		for fishSeed in mapEntitySave.caughtFishSeedList:
			seed(fishSeed)
			var characterTagSet = TagSet.new()
			characterTagSet.make_tagset_from_enum(FishEnums.charactertags)

			seed(fishSeed)
			var fishName = FishName.new()
			fishName.characterTagSet = characterTagSet
			fishName.make_name()
			
			toolTipString += "\n " + str(fishName.nameString)
		toolTipString = "Fish caught here:" + toolTipString
		toolTipString += "\nTreasure looted: " + str(mapEntitySave.treasureFound)
		$UIFocusable.tooltipString = toolTipString
	if mapEntitySave is FlockSave:
		$Sprite.texture = flockIcon
		$UIFocusable.nameString = str(mapEntitySave.flockSeed)
		var toolTipString = ""
		toolTipString = "FLOCK" 
		$UIFocusable.tooltipString = toolTipString
	if mapEntitySave is FishIslandSave:
		var fishIslandResource = mapEntitySave.fishIslandResource
		$Sprite.texture = fishIslandIcon
		$UIFocusable.nameString = fishIslandResource.fishName
		var toolTipString = fishIslandResource.description
		toolTipString = "FISH ISLAND" 
		$UIFocusable.tooltipString = toolTipString
