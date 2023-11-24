extends Spatial

signal onwall

func _on_Player_walking():
	$AnimationPlayer.play("go_run")

func _on_Player_standing():
	$AnimationPlayer.play("go_idle")

func _on_Player_reelingin():
	$AnimationPlayer.play("reelin")

func _on_Player_jumped():
	$AnimationPlayer.play("jump")

func _on_Player_landed():
	$AnimationPlayer.play("land")


func _on_CastManager_thrown():
	$blobmetarmenenanimaties/AnimationPlayer.play("throw")

func _on_CastManager_cast_cleared():
	$blobmetarmenenanimaties/AnimationPlayer.play("reset")


func _on_Player_strafing():
	$AnimationPlayer.play("go_idle")


func _on_Player_onwall(loc):
	emit_signal("onwall", loc)


func _on_CastManager_start_cast():
	$blobmetarmenenanimaties/AnimationPlayer.play("windup")
