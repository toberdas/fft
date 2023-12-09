extends Spatial

var timer = 0.0

func _process(delta):
	timer += delta
	$Sprite3D.transform.origin.y += cos(timer * 0.6) * 0.002

func show_prompt(index):
	$Sprite3D.frame = index

func _on_Timer_timeout():
	queue_free()
