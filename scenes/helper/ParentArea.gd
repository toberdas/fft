extends Area

signal child_parented
signal child_unparented
export(int, "own shape", "parent", "nodepath", "own shape node") var shapeOrigin
export(NodePath) var targetParent
export(NodePath) var shapeNode
export(Shape) var ownShape
export(NodePath) var exitShape
export(float) var importance = 0.5
export(int) var timeOutFramesWhenLeavingParent = 10

func _ready():
	if targetParent:
		if targetParent is NodePath:
			targetParent = get_node(targetParent)
	else:
		targetParent = get_parent_spatial()
	if shapeOrigin == 1:
		$CollisionShape.shape = get_parent().shape
	if shapeOrigin == 2:
		if shapeNode is NodePath:
			shapeNode = get_node(shapeNode)
		if shapeNode:
			$CollisionShape.shape = shapeNode.shape
	if shapeOrigin == 0:
		$CollisionShape.shape = ownShape
	if exitShape:
		exitShape = get_node(exitShape)

func parented(child):
	emit_signal("child_parented", child)

func unparented(child):
	emit_signal("child_unparented", child)
