extends KinematicBody

var velocity = -transform.basis.z
var stepcount = 0

signal predicthit

func step(grav, _drag):
	var poskin = move_and_collide(velocity)
	if poskin is KinematicCollision:
		emit_signal("predicthit", poskin)
	velocity.y -= grav
	stepcount += 1
	

func reset(castTime, probespeed):
	stepcount = 0
	transform.origin = Vector3(0,0,0)
	velocity = -global_transform.basis.z * (castTime * probespeed)
