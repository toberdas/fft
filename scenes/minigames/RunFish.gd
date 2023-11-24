extends MiniGame



func _ready():

	pass

func playScript(delta):
	var hdir = int(Input.is_action_pressed("moveright")) - int(Input.is_action_pressed("moveleft"))
	var vdir = int(Input.is_action_pressed("movedown")) - int(Input.is_action_pressed("moveup"))
	var dir = Vector2(hdir,vdir).normalized()
	$Fish.flee($Hook.transform.origin, 46)
	$Fish.flee($Path2D.get_curve().get_closest_point($Fish.global_transform.origin), 46)
	$Hook.transform.origin += dir * 2
