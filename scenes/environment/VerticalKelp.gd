extends Spatial


export(int) var segmentCount = 1
var meshInstances = []

func _ready():
	for i in segmentCount:
		var meshInst = $KelpSegment.duplicate()
		meshInst.translate($Top.transform.origin * i)
		add_child(meshInst)
		meshInstances.append(meshInst)
	$KelpSegment.merge_meshes(meshInstances)

