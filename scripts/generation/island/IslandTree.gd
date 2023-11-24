extends CellAddition
class_name IslandTree

var startBranch : IslandBranch
var branches = []
var data : IslandTreeData
var fruitSpawns = []
var fruitData : IslandFruitData
var scale = 0.1

func generate():
	start()

func start():
	var branch = IslandBranch.new()
	var branchUpVector = new_up_vector(Vector3.UP, true)
	var curve = Curve.new()
	curve.add_point(Vector2(0, 1.0))
	curve.add_point(Vector2(1.0, 1.0 - data.shrinkStep))
	var branchCurve = curve
	branch.curve = branchCurve
	branch.depth = 0
	branch.startPoint = Vector3.ZERO
	branch.upVector = branchUpVector
	var pointArray = make_point_array(branch)
	branch.pointArray = pointArray
	branches.append(branch)

func make_branch(oldBranch : IslandBranch, startPoint):
	var branch = IslandBranch.new()
	var branchUpVector = new_up_vector(oldBranch.upVector)
	var branchCurve = make_branch_curve(oldBranch)
	branch.curve = branchCurve
	branch.depth = oldBranch.depth + 1
	branch.startPoint = startPoint
	branch.upVector = branchUpVector
	var pointArray = make_point_array(branch)
	branch.pointArray = pointArray
	branches.append(branch)

func new_up_vector(oldUpVector : Vector3, first = false):
	var splitAxis = new_split_axis()
	var angle = data.splitAngle
	if first:
		angle *= 0.2
	var newUpVector = oldUpVector.rotated(splitAxis, angle)
	return newUpVector

func split(atGlobalPoint):
	pass

func make_point_array(currentBranch : IslandBranch):
	var pointArray = []
	var newPoint = currentBranch.startPoint
	var pointCount = 0
	var splitCount = 0
	for point in data.branchPointAmount:
		var branches = []
		pointCount += 1
		if currentBranch.depth < data.maxBranchDepth:
			if splitCount < data.splitAmountPerBranch:
				if pointCount >= data.pointsTillSplit:
					for s in data.branchPerSplit:
						if randf() - currentBranch.depth * 0.2 < data.splitChance:
							make_branch(currentBranch, newPoint)
							splitCount += 1
		pointArray.append(newPoint)
		var distanceScale = data.branchLength * pow(data.scalePerSplit, currentBranch.depth)
		newPoint += currentBranch.upVector * distanceScale
	if randf() < data.fecundity && splitCount == 0:
		var newFruitSpawnerResource = FruitSpawnerResource.new()
		newFruitSpawnerResource.location = newPoint
		newFruitSpawnerResource.upVector = currentBranch.upVector
		newFruitSpawnerResource.generate()
		fruitSpawns.append(newFruitSpawnerResource)
	return pointArray

func new_split_axis():
	var splitVector = Vector3.ZERO
	splitVector.x = rand_range(data.splitAxisXRange[0], data.splitAxisXRange[1])
	splitVector.z = rand_range(data.splitAxisZRange[0], data.splitAxisZRange[1])
	return splitVector.normalized()

func make_branch_curve(oldBranch:IslandBranch):
	var curve = Curve.new()
	if oldBranch.curve:
		var oldEnd = oldBranch.curve.interpolate(1.0)
		curve.add_point(Vector2(0, oldEnd))
		curve.add_point(Vector2(1.0, max(0.1,oldEnd - data.shrinkStep)))
	else:
		curve.add_point(Vector2(0, 1.0))
		curve.add_point(Vector2(1.0, 1.0 - data.shrinkStep))
	return curve

func initialize_instance(treeInstance):
	treeInstance.make_tree(self)
	return treeInstance
