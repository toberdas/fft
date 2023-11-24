extends LineRenderer


export(ShaderMaterial) var readyToJumpShader




func _on_Casting_castdone():
	material_override = readyToJumpShader
