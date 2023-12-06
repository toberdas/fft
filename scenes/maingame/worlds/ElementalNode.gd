extends Spatial

enum modes{calm,storm}
var currentMode = modes.calm
var transitioning = false
var transitionTimer : ProcessTimer 
var moveTowardObjects = []
var stepsPerObject = 100
var stepsTotal
var moveTowardIndex = 0

onready var wind_music_player = $WindMusicPlayer
onready var sea_music_player = $SeaMusicPlayer
onready var endless_sea = $EndlessSea
onready var sun_light = $SunLight

export(Resource) var stormResource
export(Resource) var calmResource
export(Resource) var usedEndlessSeaResource
export(Resource) var currentSkyResource
export(Environment) var skyEnvironment

func _ready():
	transitionTimer = ProcessTimer.new(100)
	endless_sea.endlessSeaResource = usedEndlessSeaResource
	start_transition()

func _process(delta):
	if transitioning:
		match currentMode:
			modes.calm:
				set_properties_to_resource(calmResource, delta)
			modes.storm:
				set_properties_to_resource(stormResource, delta)
		var transitionOver = transitionTimer.tick()
		if transitionOver:
			transitioning = false

func set_properties_to_resource(elementalResource, delta):
	wind_music_player.set_rythm_time_modifier(elementalResource.windTimeModifier)
	sea_music_player.set_rythm_time_modifier(elementalResource.seaTimeModifier)
	wind_music_player.set_flat_decibel_add(elementalResource.windDecibelAdd)
	sea_music_player.set_flat_decibel_add(elementalResource.seaDecibelAdd)
	usedEndlessSeaResource.lerp_to_target_resource(elementalResource.endlessSeaResource, .01)
	currentSkyResource.lerp_to_target_resource(elementalResource.skyResource, .01)
	sun_light.light_color = ColorUtil.move_toward_color(sun_light.light_color, elementalResource.skyResource.sunColor, .01)
	sun_light.light_energy = move_toward(sun_light.light_energy, elementalResource.sunPower, .01)
	skyEnvironment.fog_color = ColorUtil.move_toward_color(skyEnvironment.fog_color, elementalResource.skyResource.skyDarkColor, .01)
	skyEnvironment.fog_depth_begin = move_toward(skyEnvironment.fog_depth_begin, 200 * (1.0 - elementalResource.fogThickness), 100)
	skyEnvironment.fog_depth_end = move_toward(skyEnvironment.fog_depth_end, 1400 * (1.0 - elementalResource.fogThickness), 200)
	skyEnvironment.ambient_light_color = ColorUtil.move_toward_color(skyEnvironment.ambient_light_color, elementalResource.skyResource.skyDarkColor, 0.01)

#func start_transition():
#	moveTowardIndex = 0
#	moveTowardObjects = []
#	transitioning = true
#	transitionTimer.reset()
#	currentMode = HelperScripts.random_var_from_dict(modes)
#	var elementalResource
#	match currentMode:
#			modes.calm:
#				elementalResource = calmResource
#			modes.storm:
#				elementalResource = stormResource
#	var steps = stepsPerObject
#	var sunColorMove = MoveTowardsColor.new()
#	sunColorMove.start(sun_light.light_color, elementalResource.skyResource.sunColor, steps)
#	moveTowardObjects.append(sunColorMove)
#	var fogColorMove = MoveTowardsColor.new()
#	fogColorMove.start(skyEnvironment.fog_color, elementalResource.skyResource.skyDarkColor, steps)
#	moveTowardObjects.append(fogColorMove)
#	var sunEnergyMove = MoveTowardsFloat.new()
#	sunEnergyMove.start(sun_light.light_energy, elementalResource.sunPower,steps)
#	moveTowardObjects.append(sunEnergyMove)
#	var fogDepthBeginMove = MoveTowardsFloat.new()
#	fogDepthBeginMove.start(skyEnvironment.fog_depth_begin, 200 * (1.0 - elementalResource.fogThickness), steps)
#	moveTowardObjects.append(fogDepthBeginMove)
#	var fogDepthEndMove = MoveTowardsFloat.new()
#	fogDepthEndMove.start(skyEnvironment.fog_depth_end, 1400 * (1.0 - elementalResource.fogThickness), steps)
#	moveTowardObjects.append(fogDepthEndMove)
#	var ambientColorMove = MoveTowardsColor.new()
#	ambientColorMove.start(skyEnvironment.ambient_light_color, elementalResource.skyResource.skyDarkColor, steps)
#	moveTowardObjects.append(ambientColorMove)
#	stepsTotal = moveTowardObjects.size() * stepsPerObject
#	transitionTimer = ProcessTimer.new(stepsTotal)

func start_transition():
	transitioning = true
	transitionTimer.reset()
	currentMode = HelperScripts.random_var_from_dict(modes)
	
func _on_Timer_timeout():
	start_transition()	
	


	
