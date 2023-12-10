extends Sprite


var timer = 0.0

func _process(delta):
	timer += delta
	position.y += cos(timer * 0.6) * 0.003
