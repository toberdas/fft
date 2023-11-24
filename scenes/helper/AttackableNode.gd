extends Spatial

signal attacked

func attacked(attackingNode):
	if check_if_different_owner(attackingNode):
		emit_signal('attacked', attackingNode)

func check_if_different_owner(node):
	return node.owner != owner

func set_shape(shape):
	$AttackableArea/CollisionShape.shape = shape
