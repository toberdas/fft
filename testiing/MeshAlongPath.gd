extends Path
class_name MeshAlongPath

tool

export(float) var stemThickness = 1.0 		#factor used to multiply up and right vectors to increase stem width

export(int) var tesselate_tolerance = 6 
export(int) var tesselate_max = 3
export var smooth = true 					#bool if the stem is shaded smooth
export var smoothness = .5
export var uvScale = Vector2(1.0, 1.0) 		#vec2 to multiply the uv vec2 by, increase this if the stem is longer, to make the pixels on the stem smaller
export(int) var sides = 3
export(Material) var meshMaterial
export(Curve) var lengthCurve
export(Curve) var widthCurve
export(Curve) var widthCurve2

var meshInstance = null

func run():
	for child in get_children():
		child.queue_free()
	var bpoints = curve.tessellate(tesselate_max, tesselate_tolerance)
	var curlen = curve.get_baked_length() 
	var st = SurfaceTool.new() 
	st.clear()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.add_smooth_group(smooth)
	if bpoints.size() > 1:
		for i in range (bpoints.size()): 	#loop over points
			var pos = bpoints[i] 			#get the current position
			var stageoncurve = curve.get_closest_offset(pos)/curlen 			#stage on curve is needed to calculate the uv, because the points arent evenly distributed because of tesselation
			var newBasis : Basis = get_new_real_basis(stageoncurve, curve)
			var baseFactorArray = get_basis_vector_array(newBasis, sides)
			var uvx = 0.0
			for k in range(sides):										 #iterations for every corner of "cylinder"	
				var dist = get_distance_at_stage(stageoncurve)
				var widthFactor = get_width_factor(k)
				var widthFactor2 = get_width_factor2(k, stageoncurve)
				if k < sides * 0.5: #to facilitate wrapping UVS without doubling verteces, we wrap around the middle, this means uneven sides will look like shit
					uvx += 1.0/float(sides)
				else:
					uvx -= 1.0/float(sides)
				
				var uv = Vector2(stageoncurve, uvx) * uvScale

				dist *= widthFactor
				dist *= widthFactor2
				st.add_uv(uv)
				st.add_vertex(pos + baseFactorArray[k] * dist)
		for k in sides: #make the bottom
			st.add_index(0)
			st.add_index(k+1)
			st.add_index(k+2)
		for i in bpoints.size() - 1: 	#loop through all points you made verteces around again to assign indeces
			var _i = i * sides 		#multiply i by amount of sides your cylinder has
			for k in sides: 		# for every side except the last, which has to wrap back
				#make quads from 2 triangles
				if k < sides - 1:
					st.add_index(k + _i)
					st.add_index(k + _i + sides)
					st.add_index(k + _i + sides + 1)

					st.add_index(k + _i)
					st.add_index(k + _i + sides + 1)
					st.add_index(k + _i + 1)
					pass
				else: #the last quad is different, looping back on the first quad
					st.add_index(k + _i)
					st.add_index(k + _i + sides)
					st.add_index(k + _i + 1)

					st.add_index(k + _i)
					st.add_index(_i + sides)
					st.add_index(_i)
					pass
		for k in sides - 1: #make the top
			var top = bpoints.size() * sides - 1
			st.add_index(top)
			st.add_index(top - k)
			st.add_index(top - k - 1)
		var _ar = st.commit_to_arrays()
		st.generate_normals()
		var _mesh = st.commit()
		meshInstance = MeshInstance.new()
		meshInstance.mesh = _mesh
		if meshMaterial:
			meshInstance.set_surface_material(0, meshMaterial)
		add_child(meshInstance)

func get_new_real_basis(curve_offset:float, _curve:Curve3D):
	var bakedLength = _curve.get_baked_length()
	var forward = _curve.interpolate_baked((curve_offset + smoothness) * bakedLength) 	#look forward a bit
	var backward = _curve.interpolate_baked((curve_offset - smoothness) * bakedLength) 	#look backward a bit
	var forwardvec = forward - backward								 #get the direction from back to front
	forwardvec = forwardvec.normalized()
	var upvec = _curve.interpolate_baked_up_vector(curve_offset)
	var rightvec_new = forwardvec.cross(upvec).normalized() * stemThickness #cross product from forward direction with upvec gives rightvec
	var upvec_new  = rightvec_new.cross(forwardvec).normalized() * stemThickness #cross the rightvec with the forwardvec for real upvec.
	var basis = Basis(rightvec_new, upvec, forwardvec)
	return basis

func get_basis_vector_array(basis: Basis, sides : int):
	var array = []
	for i in range(sides):
		array.append(basis.y.rotated(basis.z, TAU/sides*i))
	return array

func get_distance_at_stage(stage:float):
	var distance = stemThickness
	if lengthCurve:
		distance *= lengthCurve.interpolate(stage)
	return distance

func get_width_factor(currentSide:int):
	var factor =  1.0
	if widthCurve:
		factor = widthCurve.interpolate(float(currentSide)/float(sides))
	return factor

func get_width_factor2(currentSide:int,stage:float):
	var factor = 1.0
	if widthCurve2:
		if currentSide == 0 or currentSide == sides / 2:
			factor *= 1.0
		else:
			factor *= widthCurve2.interpolate(stage)
	return factor

func add_collision():
	if meshInstance:
		meshInstance.create_convex_collision()
	pass

func get_shape():
	if meshInstance:
		if meshInstance.mesh:
			return meshInstance.mesh.create_convex_shape()

func _on_Path_curve_changed():
	run()
