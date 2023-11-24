extends Node

export var playerInventory : Resource
export var itemAtlasResource : Resource

var keys = [
	preload("res://assets/resources/items/specificItems/KEYS/BlueKey.tres"), preload("res://assets/resources/items/specificItems/KEYS/FuchsiaKey.tres"), preload("res://assets/resources/items/specificItems/KEYS/GreenKey.tres"), preload("res://assets/resources/items/specificItems/KEYS/RedKey.tres"), preload("res://assets/resources/items/specificItems/KEYS/TealKey.tres"), preload("res://assets/resources/items/specificItems/KEYS/YellowKey.tres")
]
var lootItems = [
	preload("res://assets/resources/items/specificItems/rods/BeginnersRod.tres")
]

const ThreeDItem = preload("res://scenes/item/3DItem.tscn")
const fishFaceGenerator = preload("res://scripts/generation/fishface/FishFaceGenerator.tscn")

func _enter_tree():
	itemAtlasResource = ItemAtlas.new()

func create_3d_item_from_resource(_resource):
#	var pickupResource = make_pickup_and_tally_resource(_resource)
	
	var item = ThreeDItem.instance()
	item.itemResource = _resource
#	item.pickupResource = pickupResource
	return item

func make_pickup_and_tally_resource(_itemResource):
	var _pickupResource = PickupItemResource.new()
	var nam = _itemResource["itemName"].replace(" ", "_") + "_" + str(itemAtlasResource.counter)
	itemAtlasResource.atlas[nam] = {
		pickupResource = _pickupResource
	}
	_pickupResource.id = nam
	_pickupResource.itemResource = _itemResource
	itemAtlasResource.counter += 1
	return _pickupResource

func make_itemresource_from_fishdata(fishdata : FishData):
	var itemResource = Item.new()
	itemResource.itemName = fishdata.brain.character.fishName
	itemResource.itemType = "memory"
#	itemResource.icon = make_fishface_icon(fishdata)
	itemResource.icon = preload("res://assets/img/light.png")
	itemResource.toolTip = "Serene memory, hold on dearly"
	itemResource.extendedResource = fishdata
	var pickupItem = make_pickup_and_tally_resource(itemResource)
	pickupItem.ignoreSave = true
	return pickupItem

#func make_fishface_icon(fishdata : FishData):
#	var fishfacegeninstance = fishFaceGenerator.instance()
#	add_child(fishfacegeninstance)
#	fishfacegeninstance.run(fishdata)
#	var img = fishfacegeninstance.texture.get_data()
#	fishfacegeninstance.queue_free()
#	var smallImg = img
#	smallImg.resize(128,128)
#	var iconTex = ImageTexture.new()
#	iconTex.create_from_image(smallImg)
#	return iconTex
