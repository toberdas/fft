extends Resource
class_name IslandTreeData

var splitAxisXRange
var splitAxisZRange
var splitAngle
var splitAmountPerBranch
var pointsTillSplit
var branchPointAmount
var scalePerSplit
var distancePerPoint
var maxBranchDepth
var branchPerSplit
var splitChance
var shrinkStep
var thickness
var branchLength
var fecundity

func _init():
	generate()

func generate():
	splitAxisXRange = [rand_range(-1.0,-0.5), rand_range(0.5,1.0)]
	splitAxisZRange = [rand_range(-1.0,-0.5), rand_range(0.5,1.0)]
	splitAngle = rand_range(deg2rad(-60.0), deg2rad(60.0))
	splitAmountPerBranch = 1 + randi() % 2
	branchPointAmount = 6 + randi() % 12
	pointsTillSplit = branchPointAmount - 1
	maxBranchDepth = 2 + randi() % 3
	branchPerSplit = 1 + randi() % 2
	distancePerPoint = 1.0 + randf()
	splitChance = 0.4 + randf()
	scalePerSplit = rand_range(0.6,0.8)
	shrinkStep = rand_range(0.2,0.3)
	thickness = rand_range(1.5,2.5)
	branchLength = 1 + randf() * 1
	fecundity = randf()
