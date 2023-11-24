extends Spatial

var meshes = []

func _ready():
	for child in $props.get_children():
		if child is MeshInstance:
			meshes.append(child)
	var randomMesh = HelperScripts.random_value_from_array(meshes)
	if randf() > 0.5:
		randomMesh.visible = true
