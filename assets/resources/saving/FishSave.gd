extends Resource
class_name FishSave

export(float) var fishSeed = 0
export(float) var foreignSeed = 0
export(bool) var fragmentAcquiered
export(bool) var gameWon
export(Resource) var motif

var fishData setget set_fish_data

func generate_fish_data():
	fishData = FishData.new(fishSeed, foreignSeed)
	fishData.generate()
	return fishData

func set_fish_data(newData):
	fishData = newData
	fishSeed = fishData.fishSeed
	foreignSeed = fishData.foreignSeed
	fragmentAcquiered = fishData.fragmentAcquiered
	gameWon = fishData.gameWon
