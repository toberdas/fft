extends Resource
class_name ShipResource

export var savedTransform : Transform
export var fishCaptureResource : Resource

func first_creation():
	savedTransform = Transform()
	fishCaptureResource = FishCaptureResource.new()

func from_load(loadedResource):
	savedTransform = loadedResource.savedTransform
	fishCaptureResource = FishCaptureResource.new()
	fishCaptureResource.from_load(loadedResource.fishCaptureResource)
