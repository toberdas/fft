extends Node
class_name Walk

var stepLength = 0
var islandJumpScale = 0.0
var islandScale = 0.0
var dict = {}
var platforms = []
var character = null
var parent = null
var transform = Transform()
var restricted = true
var resolution = 0.01

var branchTotal = 0
var branchCount = 0

signal branch_end
signal walk_end
signal branch_split
signal point_added

func _init(_character, _parent, sl = 4, bt = 1, _restricted = false, _resolution = 1.0, ijs = 12.0, iss = 4.0):
	resolution = _resolution
	restricted = _restricted
	parent = _parent
	character = _character
	stepLength = sl
	islandJumpScale = ijs
	islandScale = iss
	branchTotal = bt
	make_transform(_parent)
	run(WalkPoint.new(Vector3.ZERO, 0, [Vector3(resolution,0.0,0.0)]))
	print(dict)

func make_transform(parent):
	transform.origin = parent.transform.origin + parent.transform.basis.y * 0.5
	transform.basis = Basis(parent.transform.basis.get_rotation_quat())

func run(oldwalkpoint = WalkPoint.new()):
	var i = oldwalkpoint.latestIndex
	var olddir = oldwalkpoint.connections.back()
	var point = oldwalkpoint.matrixPoint
	var sp = oldwalkpoint.islandSpacePosition
	var newPlat = false
	var walkPoint = null
	if dict.has(point + olddir):
		walkPoint = dict[point + olddir]
	else:
		newPlat = true
		walkPoint = WalkPoint.new()
		dict[point + olddir] = walkPoint
		
	walkPoint.matrixPoint = point + olddir
	walkPoint.islandSpacePosition =  sp + to_island_space(point, olddir)
	
	var dir = get_direction(olddir)
	if restricted:
		while (point + dir).x < -1.0 or (point + dir).x > 1.0 or (point + dir).z < -1.0 or (point + dir).z > 1.0:
			dir = get_direction(olddir)
		
	walkPoint.latestIndex = i + 1
	walkPoint.connections.append(dir)
	
	if newPlat:
		emit_signal("point_added", walkPoint)
		if restricted:
			var mvec = walkPoint.matrixPoint.x * parent.transform.basis.x * 0.5
			mvec += walkPoint.matrixPoint.z * parent.transform.basis.z * 0.5
			mvec.y += walkPoint.matrixPoint.y * 3 + randf() * 2
			platforms.append(IslandPlatform.new(character, transform.origin + mvec, null, transform.basis))
		else:
			platforms.append(IslandPlatform.new(character, transform.origin + walkPoint.islandSpacePosition, null, transform.basis))
	
	if i >= stepLength:
		emit_signal("branch_end", walkPoint)
		if branchCount < branchTotal:
			branchCount += 1
			emit_signal("branch_split", walkPoint)
			if randf() > 0.2:
				walkPoint.latestIndex = 0
				walkPoint.connections[-1] = walkPoint.connections.back().rotated(Vector3.UP, deg2rad(90))
				run(walkPoint)
			if randf() > 0.2:
				walkPoint.latestIndex = 0
				walkPoint.connections[-1] = walkPoint.connections.back().rotated(Vector3.UP, deg2rad(-90))
				run(walkPoint)
		else:
			emit_signal("walk_end", walkPoint)
		return
	
	run(walkPoint)
	
func to_island_space(matrixpoint, dir):
	var ndir = dir.rotated(Vector3.UP, randf() * .2)
#	var ndir = dir
	ndir.y += randf()
	ndir *= Vector3(islandJumpScale, islandJumpScale * 0.25, islandJumpScale) * (1.0)
	return ndir

func get_direction(olddir):
	olddir *= Vector3(1,0,1)
	var wd = WeightedDistribution.new()
	wd.add_option(olddir, 4)
	wd.add_option(olddir.rotated(Vector3.UP, deg2rad(90)), 1)
	wd.add_option(olddir.rotated(Vector3.UP, deg2rad(-90)), 1)
	var dir = wd.roll()
	
	wd.clear()
	wd.add_option(0, 2)
	wd.add_option(1, 5)
	dir.y = wd.roll()
	return dir
