extends Spatial

export var rayLength = 3.0 setget set_ray_length

var cooldown = 2
signal wall_sensed

func _process(_delta):
	if cooldown <= 0:
		check_for_walls()
		cooldown = 2 + randi() % 2
	else:
		cooldown -=1

func _ready():
	set_ray_length(rayLength)
	var _ce = $Timer.connect("timeout", self, "check_for_walls")

func check_for_walls():
	var cc = 0 				#col count
	var cp = Vector3.ZERO 	#colpoint
	var cn = Vector3.ZERO 	#colnorm
	for child in get_children():
		if child is RayCast:
			if child.is_colliding():
				cp += child.get_collision_point()
				cn += child.get_collision_normal()
				cc += 1
	if cc>0:
		cp /= cc
		cn /= cc
		cn = cn.normalized()
		get_evade_velocity(cp, cn, rayLength)
	pass

func get_evade_velocity(point, normal, raylength):
	var colDist = min(rayLength,(global_transform.origin-point).length())
	var distFact = 1 - (colDist / raylength)
	emit_signal("wall_sensed", {"collisionFactor" : distFact, "collisionNormal" : normal})

func set_ray_length(newlength):
	for child in get_children():
		if child is RayCast:
			child.cast_to = child.cast_to * newlength
