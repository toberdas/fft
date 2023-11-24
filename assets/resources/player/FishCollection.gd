extends Resource
class_name FishCollection

const fishScene = preload("res://scenes/fish/FishNode.tscn")

export var fishDataDict = {}
export var fishSceneDict = {}

func make_scene_dict_from_data_dict():
	for fishData in fishDataDict:
		var fishSceneInstance = create_fish_scene_from_data(fishData)
		fishSceneDict[fishData.name] = fishSceneInstance

func create_fish_scene_from_data(fishData):
	var fishSceneInstance = fishScene.instance()
	fishSceneInstance.fishData = fishData
	return fishSceneInstance
