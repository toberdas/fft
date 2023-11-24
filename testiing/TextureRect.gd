extends TextureRect



func _on_SeaChunk_camera_submerged(really):
	if really:
		material.set_shader_param('bluemult', 2.0)
	else:
		material.set_shader_param('bluemult', 1.0)
