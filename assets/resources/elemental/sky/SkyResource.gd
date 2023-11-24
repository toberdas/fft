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
	sunColor = ColorUtil.move_toward_color(sunColor,targetResource.sunColor, delta)
	skyLightColor = ColorUtil.move_toward_color(skyLightColor,targetResource.skyLightColor, delta)
	skyDarkColor = ColorUtil.move_toward_color(skyDarkColor,targetResource.skyDarkColor, delta)
