extends Spatial


signal netted


func _on_AttackableNode_attacked(attackingNode):
	if attackingNode.is_in_group("Player"):
		emit_signal("netted", attackingNode)
