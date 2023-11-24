extends RigidBody


func _on_SeaCheckComponent_submerged():
	gravity_scale = -1


func _on_SeaCheckComponent_emerged():
	gravity_scale = 1
