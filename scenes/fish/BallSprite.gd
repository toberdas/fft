extends Sprite

signal heart_warmed

var warmed = false

func _process(delta):
	if !warmed:
		if $AnimationPlayer.playback_speed > 1.0:
			$AnimationPlayer.playback_speed -= delta * 0.5

func _on_2DPickable_picked(_picker):
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.playback_speed -= 0.4
	else:
		if $AnimationPlayer.playback_speed < 1.2:
			$AnimationPlayer.playback_speed += 0.6
			$AnimationPlayer.play("bounce")
		else:
			$AnimationPlayer.play("bounce (outro)")
			heart_warmed()

func heart_warmed():
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("RESET")
	emit_signal("heart_warmed")
