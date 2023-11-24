extends MeshInstance

func _process(_delta):
	if GlobalSingleton.player:
		get_active_material(0).set_shader_param("PlayerPosition", GlobalSingleton.player.global_transform.origin)
