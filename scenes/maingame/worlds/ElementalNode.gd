extends Spatial

enum modes{calm,storm}
var currentMode = modes.storm
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
	endless_sea.endlessSeaResource = usedEndlessSeaResource

func _process(delta):
	match currentMode:
		modes.calm:
			set_properties_to_resource(calmResource, delta)
		modes.storm:
			set_properties_to_resource(stormResource, delta)

func set_properties_to_resource(elementalResource, delta):
	usedEndlessSeaResource.lerp_to_target_resource(elementalResource.endlessSeaResource, .02)
	currentSkyResource.lerp_to_target_resource(elementalResource.skyResource, .02)
	wind_music_player.set_rythm_time_modifier(elementalResource.windTimeModifier)
	sea_music_player.set_rythm_time_modifier(elementalResource.seaTimeModifier)
	wind_music_player.set_flat_decibel_add(elementalResource.windDecibelAdd)
	sea_music_player.set_flat_decibel_add(elementalResource.seaDecibelAdd)
	sun_light.light_color = sun_light.light_color.linear_interpolate(elementalResource.skyResource.sunColor, .2)
	sun_light.light_energy = move_toward(sun_light.light_energy, elementalResource.sunPower, .02)
	skyEnvironment.fog_color = skyEnvironment.fog_color.linear_interpolate(elementalResource.skyResource.skyDarkColor, .2)
	skyEnvironment.fog_depth_begin = move_toward(skyEnvironment.fog_depth_begin, 200 * (1.0 - elementalResource.fogThickness), 100)
	skyEnvironment.fog_depth_end = move_toward(skyEnvironment.fog_depth_end, 1400 * (1.0 - elementalResource.fogThickness), 100)
	skyEnvironment.ambient_light_color = skyEnvironment.ambient_light_color.linear_interpolate(elementalResource.skyResource.skyDarkColor, 0.2)

func _on_Timer_timeout():
	currentMode = HelperScripts.random_var_from_dict(modes)
