extends Spatial

var target = null
export var monsterSpeed = 15.0

func _process(delta):
	if target:
		global_transform.origin.y += delta * monsterSpeed
		global_transform.origin.x = target.global_transform.origin.x
		global_transform.origin.z = target.global_transform.origin.z
	else:
		global_transform.origin.y -= delta * monsterSpeed

func _on_Area_body_entered(body):
	$Monster/AnimationPlayer.play("eat")

func eat_all():
	for body in $Area.get_overlapping_bodies():
		body.die()
	target = null
