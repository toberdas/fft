extends Control


func init_from_resource(warningResource:WarningResource):
	$CenterContainer/Label.text = warningResource.text
	$Timer.wait_time = warningResource.lifetime

func start():
	$AnimationPlayer.play("start")

func death():
	$AnimationPlayer.play_backwards("start")
	yield($AnimationPlayer,"animation_finished")
	get_parent().queue_free()

func _on_Timer_timeout():
	death()
