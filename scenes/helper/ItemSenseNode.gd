extends Spatial

signal item_sensed

func _on_Area_body_entered(body):
	emit_signal("item_sensed", body)
