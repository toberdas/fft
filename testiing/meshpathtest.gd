extends Spatial


const meshPath = preload("res://testiing/MeshAlongPathInstance.tscn")
var treeData

func _ready():
	treeData = IslandTreeData.new()

func _on_Spatial_test1():
	for child in get_children():
		child.queue_free()
	randomize()
	
	var newTree = IslandTree.new()
	newTree.data = treeData
	newTree.generate()
	for branch in newTree.branches:
		var meshPathInstance = meshPath.instance()
		for point in branch.pointArray:
			meshPathInstance.curve.add_point(point)
		add_child(meshPathInstance)
		meshPathInstance.lengthCurve = branch.curve
		meshPathInstance.sides = 4
		meshPathInstance.stemThickness = treeData.thickness
		meshPathInstance.run()

func _on_Spatial_test2():
	var fishmeshdata = FishMeshCurveData.new()
	$FishPath.run_from_data(fishmeshdata)
