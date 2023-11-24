extends Spatial


var fishCaptureResource

# Called when the node enters the scene tree for the first time.
func _ready():
	fishCaptureResource = FishCaptureResource.new()
	for i in range(12):
		randomize()
		var sd = randf()
		var fd = FishData.new()
		fd.generate()
		fishCaptureResource.add_from_data(fd)
	fishCaptureResource.get_data_list()
	$ShipFishList.fishCaptureResource = fishCaptureResource
