extends Resource
class_name SkyResource

export(float) var coverage = .5
export(float) var cloudSpeedModifier = 0.1
export(float) var thickness = 10
export(float) var absorption = 1.0
export(Color) var sunColor
export(Color) var skyLightColor
export(Color) var skyDarkColor

func lerp_to_target_resource(targetResource : SkyResource, delta):
	absorption = move_toward(absorption, targetResource.absorption, delta)
	thickness = move_toward(thickness, targetResource.thickness, delta)
	coverage = move_toward(coverage, targetResource.coverage, delta)
	cloudSpeedModifier = move_toward(cloudSpeedModifier, targetResource.cloudSpeedModifier, delta)
	sunColor = sunColor.linear_interpolate(targetResource.sunColor, delta)
	skyLightColor = skyLightColor.linear_interpolate(targetResource.skyLightColor, delta)
	skyDarkColor = skyDarkColor.linear_interpolate(targetResource.skyDarkColor, delta)
