extends Spatial
class_name SeaBobber

var active = true

export var targetUpVelocity = 12.0
export var targetDownVelocity = -12.0

export var upAccel = 20.0
export var downAccel = 20.0

var targetVelocity = targetDownVelocity
var fallVelocity = 0.0
var accel = downAccel

func _process(delta):
	if active:
#		fallVelocity = move_toward(fallVelocity, targetVelocity, accel * delta)
#		global_transform.origin.y += fallVelocity * delta
		global_transform.origin.y = $SeaHeightComponent.height


func _on_SeaCheckComponent_emerged():
	targetVelocity = targetDownVelocity
	accel = downAccel

func _on_SeaCheckComponent_submerged():
	targetVelocity = targetUpVelocity
	accel = upAccel
