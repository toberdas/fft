extends Resource
class_name ItemAtlas

export var atlas = {}
export var counter = 0

func from_load(loadedResource):
	counter = loadedResource.counter
	var loadedAtlas = loadedResource.atlas
	for key in loadedAtlas.keys():
		var newResource = PickupItemResource.new()
		newResource = newResource.from_load(loadedAtlas[key]["pickupResource"])
		if newResource:
			atlas[key] = {
				pickupResource = newResource
			}
