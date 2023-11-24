extends Resource
class_name WorldMap

export var seeed : int
export var islandPoints : Array  setget ,get_island_points
export var islandAmount : int
export var flockAmount : int
export var flockPoints : Array
export var allEntities : Array setget ,get_all_entities
export var startIslandSave : Resource

var visitDict = {}

const worldMapDefinition = preload("res://assets/resources/map/WorldMapDefinition.tres")
signal point_added
signal map_ready

func generate():
	seed(seeed)
	allEntities = []
	islandAmount = worldMapDefinition.islandAmount + randi() % worldMapDefinition.islandAmountVariance
	flockAmount = worldMapDefinition.flockAmount + randi() % worldMapDefinition.flockAmountVariance
	place_island_points()
	place_flocks()
	place_island_fish()
	emit_signal("map_ready")

func update():
	for entitySave in allEntities:
		entitySave.update(self)

func place_island_points():
	var wd = WeightedDistribution.new()
	wd.add_option(1, int(islandAmount * 0.6))
	wd.add_option(2, int(islandAmount * 0.3))
	wd.add_option(3, int(islandAmount * 0.2))
	wd.add_option(4, int(islandAmount * 0.1))
	wd.add_option(5, int(islandAmount * 0.1))
	wd.add_option(6, int(islandAmount * 0.1))
	
	seed(seeed)
	islandPoints.clear()
	var startPoint = Vector2(0.5,0.5)
	islandPoints.append(startPoint)
	var save = make_new_islandsave(startPoint, 4)
	allEntities.append(save)
	startIslandSave = save
	var fsave = make_new_flocksave()
	fsave.point = startPoint
	fsave.targetPoint = startPoint
	fsave.targetSave = save
	allEntities.append(fsave)

	var er = 0
	while islandPoints.size() < islandAmount && er < 10:
		var p = Vector2(NormalDistribution.normal_distribution(), NormalDistribution.normal_distribution())
		var er1 = 0
		while !test_position(p) && er1 < 10:
			p = Vector2(NormalDistribution.normal_distribution(), NormalDistribution.normal_distribution())
			er1 += 1
		var wdr = wd.roll(true)
		var newsave = make_new_islandsave(p, wdr)
		allEntities.append(newsave)
		islandPoints.append(p)
		emit_signal("point_added")
		er += 1


func place_flocks():
	for i in range(flockAmount):
		var save = make_new_flocksave()
		allEntities.append(save)
	pass

func place_island_fish():
	for fishIslandResource in worldMapDefinition.fishIslandCollection.fishIslandResourceList:
		var newFishIslandSave = FishIslandSave.new()
		newFishIslandSave.sceneName = worldMapDefinition.mapEntitySettings.fishIslandSceneName
		newFishIslandSave.loadDistance = worldMapDefinition.mapEntitySettings.fishIslandLoadDistance
		newFishIslandSave.point = HelperScripts.random_vec2()
		newFishIslandSave.targetPoint = HelperScripts.random_vec2()
		newFishIslandSave.moveSpeed = 0.0001
		newFishIslandSave.maxTimeAtTarget = worldMapDefinition.mapEntitySettings.fishIslandTimeAtTarget
		newFishIslandSave.fishIslandResource = fishIslandResource
		allEntities.append(newFishIslandSave)

func make_new_islandsave(point, tier):
	var save = IslandSave.new()
	save.sceneName = worldMapDefinition.mapEntitySettings.islandSceneName
	save.loadDistance = worldMapDefinition.mapEntitySettings.islandLoadDistance
	save.point = point
	save.tier = tier
	save.islandSeed = hash(randf())
	return save

func make_new_flocksave():
	var save = FlockSave.new()
	save.sceneName = worldMapDefinition.mapEntitySettings.flockSceneName
	save.loadDistance = worldMapDefinition.mapEntitySettings.flockLoadDistance
	var targetSave = get_closest_entity(HelperScripts.random_vec2(), IslandSave)
	if !targetSave:
		print_debug('No island found, defaulting to middle island with any amount of visitors')
		get_closest_entity(Vector2(0.5,0.5), IslandSave, 99)
	save.point = targetSave.point
	save.targetPoint = targetSave.point
	save.targetSave = targetSave
	save.flockSeed = hash(randf())
	return save

func test_position(position:Vector2):
	var tf = true
	for pos in islandPoints:
		if (position - pos).length() < GameplayConstants.minDistanceBetweenIslands:
			tf = false
	return tf

func is_point_free(position:Vector2, distance: float, typeStringArray:Array=[]):
	var tf = true
	for entity in allEntities:
		var pos = entity.point
		if typeStringArray.size()>0:
			if typeStringArray.has(entity.get_class()):
				if (position - pos).length() < distance:
					tf = false
		else:
			if (position - pos).length() < distance:
				tf = false
	return tf

func leave_entity(save:MapEntitySave):
	if visitDict.has(save):
		visitDict[save] -= 1

func get_closest_entity(point, type = null, maxVisitors = 2):
	var dist = 1.0
	var rv = null
	for entity in allEntities:
		if type:
			if !entity is type :
				continue
		if visitDict.has(entity):
			if visitDict[entity] > maxVisitors:
				continue
		var newdist = (entity.point - point).length()
		if newdist < dist:
			dist = newdist
			rv = entity
	if visitDict.has(rv):
		visitDict[rv] += 1
	else:
		visitDict[rv] = 1
	return rv

func get_island_points():
	return islandPoints

func get_all_entities():
	return allEntities
