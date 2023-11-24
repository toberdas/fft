extends MeshInstance
tool


export(Material) var stemMaterial


# Called when the node enters the scene tree for the first time.
func _ready():
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.add_uv(Vector2(0,0))
	st.add_vertex(Vector3(0,-1,0))
	st.add_uv(Vector2(1,0))
	st.add_vertex(Vector3(0,-1,1))
	st.add_uv(Vector2(0,1))
	st.add_vertex(Vector3(-1,1,0))
	st.add_uv(Vector2(0,1))
	st.add_vertex(Vector3(-1,1,0))
	st.add_uv(Vector2(1,0))
	st.add_vertex(Vector3(0,-1,1))
	st.add_uv(Vector2(1,1))
	st.add_vertex(Vector3(-1,1,1))
	st.index()
	st.generate_normals()
	st.generate_tangents()
	var _mesh = st.commit()
	_mesh.surface_set_material(0, stemMaterial)
	mesh = _mesh

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
