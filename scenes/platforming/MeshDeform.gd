extends MeshInstance
class_name MeshDeform

export(NoiseTexture) var noiseTex
export(Vector3) var scaleVector

func _ready():
	deform()
	pass

func deform(withCollision = true):
	var deformedArrays = get_deformed_arrays_from_mesh(mesh)
	var newMesh = create_new_mesh_from_arrays(deformedArrays)
	mesh = newMesh
	var shape = mesh.create_trimesh_shape()
	if withCollision:
		create_trimesh_collision()

func get_deformed_arrays_from_mesh(myMesh):
	var meshArray = get_mesh_array(myMesh)
	var displacedLocationArray = displace_location_array(meshArray)
	meshArray[0] = displacedLocationArray
	return meshArray

func create_new_mesh_from_arrays(arrays):
	var newMesh = ArrayMesh.new()
	newMesh.add_surface_from_arrays(ArrayMesh.PRIMITIVE_TRIANGLES, arrays)
	return newMesh

func displace_location_array(meshArray):
	var locationArray = meshArray[0]
	var normalsArray = meshArray[1]
	var array = []
	for i in range(locationArray.size()):
		var point = locationArray[i]
		var normal = normalsArray[i]
		var displacementVector = get_location_displacement(point)
		var scaledDisplacementVector = normal * displacementVector * scaleVector
		point += scaledDisplacementVector
		array.append(point)
		i += 1
	return array

func get_location_displacement(loc):
	loc = to_global(loc)

	var noiseValX = sample_noise_1d(loc.x)
	var noiseValY = sample_noise_1d(loc.y)
	var noiseValZ = sample_noise_1d(loc.z)
	var collectedNoise = Vector3(noiseValX, noiseValY, noiseValZ)

	return collectedNoise

func get_surrounding_normal():
	pass

func sample_noise_1d(loc):
	return noiseTex.noise.get_noise_1d(loc)

func sample_noise_location(_noiseTex : NoiseTexture, loc):
	return _noiseTex.noise.get_noise_3dv(loc)

func get_mesh_array(myMesh):
	return myMesh.surface_get_arrays(0)

func set_noise_seed(newSeed):
	noiseTex.noise.seed = newSeed
