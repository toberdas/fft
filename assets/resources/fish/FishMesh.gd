extends MeshPicker

func glow(yn):
	if yn == true:
		activeMesh.get_surface_material(0).set_next_pass(preload("res://assets/materials/mat_3d_outline.tres")) #if glow is true then set the outline material as a next pass in material
	if yn == false:
		activeMesh.get_surface_material(0).set_next_pass(null)


func _on_Fish_fishready(fish):
	activeMesh.get_surface_material(0).set_local_to_scene(true)
	activeMesh.get_surface_material(0).set_shader_param('albedo', fish.fishData.color)
