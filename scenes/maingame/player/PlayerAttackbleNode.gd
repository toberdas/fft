extends Spatial

export var recoverTime = 1.0


signal playerattacked
signal playerrecovered

func attacked(attackingNode):
	emit_signal("playerattacked", attackingNode)
	$Timer.start(recoverTime)

func _on_AttackableNode_attacked(attackingNode):
	attacked(attackingNode)

func _on_Timer_timeout():
	emit_signal("playerrecovered")


func _on_NetNode_wall_bashed(wall):
	attacked(wall)
