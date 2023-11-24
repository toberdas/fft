extends Timer


func _process(delta):
	$Label.text = str(wait_time)
