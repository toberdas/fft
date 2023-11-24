extends Node
class_name Beach

var mesh = null
var colShape = null

func _init(point = Vector2(0.5, 0.5), character = IslandCharacter.new()):
	run(point)
	character.physical.toInstance['beach'].append(self)

func run(point):
	point = point - Vector2(0.5,0.5)
	var basemesh = PlaneMesh.new()
	basemesh.subdivide_depth = 100
	basemesh.subdivide_width = 100
	var mdt = MeshDataTool.new()
	mesh = ArrayMesh.new()
	var noise = OpenSimplexNoise.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, basemesh.get_mesh_arrays())
	mdt.create_from_surface(mesh, 0)
	for i in range(mdt.get_vertex_count()):
		var vert = mdt.get_vertex(i)
		var vertnorm = mdt.get_vertex_normal(i)
		var disttoseed = (vert - Vector3(point.x, 0.0, point.y)).length()
		vert.y += noise.get_noise_3dv(vert * 100) * 6.0 - disttoseed * 12.0
		mdt.set_vertex(i, vert)
		pass
	mesh.surface_remove(0)
	mdt.commit_to_surface(mesh)
	colShape = mesh.create_trimesh_shape()
