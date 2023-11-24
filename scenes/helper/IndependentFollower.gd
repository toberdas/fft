extends Follower
class_name IndependentFollower

func _ready():
	if target:
		if target is NodePath:
			target = get_node(target)
		mission(target, mode, followMultiplier)
	set_as_toplevel(true)
