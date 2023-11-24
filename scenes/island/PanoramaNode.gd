extends Spatial

export(Material) var panMat
var resource = null
export(Curve) var fallofCurve

func _on_IslandNode_start_initialize(res, _player):
	resource = res.mood

func _on_VibeManager_update_mood(distrat):
	if distrat:
		distrat = fallofCurve.interpolate(distrat)
		if distrat > 0.0:
			panMat.set_shader_param("targ_pan_tex", resource.panoramaTexture)
		panMat.set_shader_param("targ_fac", distrat)
