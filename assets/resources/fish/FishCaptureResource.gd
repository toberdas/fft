extends Resource
class_name FishCaptureResource

export var captureDict = {}

func add_from_fish(fish):
	if fish.fishData:
		add_from_data(fish.fishData)

func add_from_data(fishData : FishData):
	var fishSave = FishSave.new()
	fishSave.fishData = fishData
	captureDict[fishData.fishSeed] = fishSave

func from_load(loadedResource):
	captureDict = loadedResource.captureDict

func get_data_list():
	var ar = []
	for key in captureDict.keys():
		var save : FishSave = captureDict[key]
		var fishData
		if save.fishData:
			fishData = save.fishData
		else:
			save.generate_fish_data()
			fishData = save.fishData
		ar.append(fishData)
	return ar
		
func clear_list():
	captureDict = {}

func release_all_fish():
	for key in captureDict.keys():
		release_fish(key)

func release_fish(key):
	var item = captureDict[key]
	if item:
		if item.has("data"):
			item["data"].brain.go_to_rest_state()
		captureDict.erase(key)

func get(key):
	var rv = null
	if captureDict.has(key):
		rv = captureDict[key]
	return rv
