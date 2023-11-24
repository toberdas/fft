extends MapEntitySave
class_name IslandSave

export(float) var islandSeed
export(bool) var treasureFound = false
export(bool) var treasureLooted = false
export(int) var tier = 1
export(Array) var caughtFishSeedList = []

var islandResource

func get_island_real_surfaces():
	if islandResource:
		return islandResource.get_real_surfaces()

func generate_at_once():
	while !generate_resource_step():
		return false
	return true

func generate_resource_step():
	if !islandResource:
		islandResource = IslandResource.new()
		islandResource.islandSave = self
		return false
	else:
		if islandResource.generation_step():
			islandSeed = islandResource.islandSeed ##if the old seed made a dead island, get new seed from resource
			return true
		else:
			return false

func treasure_found():
	treasureFound = true

func treasure_looted():
	treasureLooted = true
