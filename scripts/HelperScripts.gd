extends Node
class_name Helper
tool

func limited_append(val,ar,lim):
	ar.append(val)
	if ar.size() > lim:
		ar.pop_front()

func get_average(ar):
	var i = 0
	var av = 0
	for val in ar:
		av += val
		i += 1
	return av / i

func nearest_point_on_sphere(sphereOrigin: Vector3, sphereRadius: float, point: Vector3):
	var dir = point - sphereOrigin
	dir = dir.normalized()
	dir *= sphereRadius
	dir += sphereOrigin 
	return dir

func random_vec3():
	return Vector3(randf(),randf(),randf())
	
func random_vec2():
	return Vector2(randf(),randf())

func scale_array(ar, reso): #used by casting to scale down the array of points received from predict
	var newar = []
	var leng = ar.size()
	var ratio = (leng/(reso - 1))
	for i in range(reso - 1):
		newar.append(ar[floor(ratio * i)])
	newar.push_back(ar.back()) #push back the last position so that the bobber ends up exactly at the end of the predict line
	return newar

func curve_to_array(path, arraylength): #used by casting to make an array of points to draw from curve that moves with chainlinks
	var newar = []
	var nf = PathFollow.new()
	path.add_child(nf)
	nf.global_transform = path.global_transform
	for i in range(arraylength):
		nf.set_unit_offset(float(i)/float(arraylength))
		newar.append(nf.global_transform.origin)
	nf.queue_free()
	return newar

func interpolate_arrays(arrayfrom : Array, arrayto : Array, weight : float):
	var ar = arrayfrom
	for i in range(arrayfrom.size()):
		if i < arrayto.size():
			ar[i] = lerp(arrayfrom[i], arrayto[i], weight)
	return ar
	
func vec_to_array(vector, arraysize, offset):
	var ar = []
	for i in range(arraysize):
		ar.append(vector * i / arraysize + offset)
	return ar

func get_nodes_from_paths(patharray, callingnode):
	var na = []
	for path in patharray:
		na.append(callingnode.get_node(path))
	return na

func random_value_from_array(array):
	if array.size() > 0:
		return array[randi() % array.size()]
	else:
		return null

func random_index_from_array(array):
	if array.size() > 0:
		return randi() % array.size()
	else:
		return null
	
func set_node_params(node: Object, paramDict: Dictionary):
	if is_instance_valid(node):
		for key in paramDict.keys():
			if key in node:
				node.set(key, paramDict[key])

func ray_from_view(position, depth, callingnode, _mask : int = 0):
	var pssds : PhysicsDirectSpaceState = callingnode.get_tree().get_root().get_world().direct_space_state
	var poso = get_viewport().get_camera().project_position(position, 0.0)
	var posto = get_viewport().get_camera().project_position(position, depth)
	var coll = pssds.intersect_ray(poso, posto, [], 0x7FFFFFFF, true, true)
	return coll

func make_kinematic_collision(parentnode : MeshInstance, layermask):
	var shape = parentnode.mesh.create_trimesh_shape()
	var kine = KinematicBody.new()
	kine.set_collision_layer_bit(0, false)
	kine.set_collision_layer_bit(layermask, true)
	parentnode.add_child(kine)
	var shapnode = CollisionShape.new()
	shapnode.shape = shape
	kine.add_child(shapnode)

func make_grid(w, h, initial_val):
	var gridar = []
	for _w in w:
		gridar.append([])
		for _h in h:
			gridar[_w].append(initial_val)
	return gridar

func grid_to_array(grid):
	var ar = []
	for i in range(grid.size()):
		for j in range(grid[i].size()):
			ar.append(grid[i][j])
	return ar

func remove_from_array(_array, _value):
	while _array.has(_value):
		_array.erase(_value)
	return _array

func fraction_array(_array, frac):
	var leng  = _array.size()
	var ind = round(leng * frac)
	return _array.slice(0, ind)
	
func switch_parent(node, newparent):
	var parent = node.get_parent()
	parent.remove_child(node)
#	node.get_parent().call_deferred("remove_child", node)s
	newparent.add_child(node)
	
func switch_parent_keep_transform(node, newparent):
	var trans = node.global_transform
	
	node.get_parent().remove_child(node)
	node.global_transform = trans
	newparent.add_child(node)
	node.global_transform = trans
	
func accumulate_array(array):
	var w = 0
	for i in array:
		w += i
	return w

func add_up_arrays(array1, array2):
	var returnar = []
	for i in range(array1.size()):
		returnar.append(array1[i] + array2[i])
	return returnar



func random_var_from_dict(en):
	return en.values()[randi() % en.keys().size()]

func fifty_fifty_bool():
	var r = randf()
	if r >= 0.5:
		return true
	else:
		return false

func random_key_from_dict(dict):
	return dict.keys()[randi() % dict.keys().size()]
