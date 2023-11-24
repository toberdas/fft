extends Resource
class_name PlayerResource

export var inventoryResource : Resource
export var equipResource : Resource
export var buffCollection : Resource
export var savedTransform : Transform
export var fishCaptureResource : Resource



func first_creation():
	inventoryResource = InventoryResource.new()
	equipResource = preload("res://assets/resources/player/PlayerEquipResource.tres")
	buffCollection = BuffCollection.new()
	fishCaptureResource = FishCaptureResource.new()
	savedTransform = Transform()
	savedTransform.origin = Vector3(GameplayConstants.worldSize.x * 0.5, 0.0, GameplayConstants.worldSize.y * 0.5)


func from_load(loadedPlayerResource):
	savedTransform = loadedPlayerResource.savedTransform
	inventoryResource = InventoryResource.new()
	inventoryResource.from_load(loadedPlayerResource.inventoryResource)
	buffCollection = BuffCollection.new()
	fishCaptureResource = FishCaptureResource.new()
	fishCaptureResource.from_load(loadedPlayerResource.fishCaptureResource)
	equipResource = loadedPlayerResource.equipResource
