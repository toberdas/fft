extends Position3D


func _process(delta):
	$IKTarget.transform.origin = lerp($IKTarget.transform.origin, Vector3.ZERO, delta)

func _on_BlobScene_onwall(loc):
	$IKTarget.global_transform.origin = lerp($IKTarget.global_transform.origin, loc, 0.2)
