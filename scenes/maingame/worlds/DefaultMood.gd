extends Node

export(Resource) var moodResource
export(Resource) var panMat

func _process(delta):
	if is_instance_valid(GlobalSingleton.cam):
		var env = GlobalSingleton.cam.environment
		env.background_color = env.background_color.linear_interpolate(moodResource.primaryColor, 0.01)
	#	env.fog_color = env.fog_color.linear_interpolate(moodResource.primaryColor, 0.01)
		env.ambient_light_color = env.ambient_light_color.linear_interpolate(moodResource.secondaryColor, 0.01)	
		panMat.set_shader_param("primary_color", env.background_color)
	
