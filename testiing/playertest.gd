extends Spatial

func _ready():
	var flockSave = FlockSave.new()
	$Flock.init(flockSave)
	$Chest.treasureResource = TreasureResource.new()
	$ElementalNode/EndlessSea.scale_and_check_position(Vector3.ZERO, true)
