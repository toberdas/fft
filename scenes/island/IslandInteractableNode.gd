extends Spatial

var resource = null
var islandSave = null
var interactableSceneArray = []
const chestScene = preload("res://scenes/interacts/specific/Chest.tscn")
var treasureChestInstance = null

func _on_IslandNode_start_initialize(save):
	resource = save.islandResource
	islandSave = save
	create_interactables()
	
func create_interactables():
#	var interactableArray = resource.interactableCollection.interactables
#	for interactable in interactableArray:
#		var intscene = interactable.scene.instance()
#		intscene.transform.origin = interactable.location
#		intscene.transform.basis = intscene.transform.basis.rotated(intscene.transform.basis.y, randf())
#		add_child(intscene)
#		interactableSceneArray.append(intscene)

	var treasureResource = resource.islandDoodads.treasureResource
	if treasureResource && islandSave.treasureFound == false:
		
		treasureChestInstance = chestScene.instance()
		add_child(treasureChestInstance)
		treasureChestInstance.connect("treasure_found",self,"register_treasure_found")
		treasureChestInstance.transform.origin = treasureResource.location
		treasureChestInstance.matchingKey = treasureResource.key

func register_treasure_found():
	islandSave.treasureFound = true


func _on_IslandTriggerNode_all_triggers_hit():
	treasureChestInstance.unearth()

