extends Spatial
class_name Follower

export var MOVESPEED = .4
export(NodePath) var target
export var followMultiplier = 1.0
export(String, "transform", "origin", "lookat", "child") var mode = "transform"
export(bool) var instant = false
var active = true


signal unfollowed

func _ready():
	if target:
		if target is NodePath:
			target = get_node(target)
		mission(target, mode, followMultiplier)
#		if target.has_method("follow_this"):
#			target.follow_this(self)
	
func _process(delta):
	if is_instance_valid(target) && active:
		if mode == "transform":
			if instant:
				global_transform = target.global_transform
			else:
				global_transform = global_transform.interpolate_with(target.global_transform, MOVESPEED)
		if mode == "origin":
			if instant:
				global_transform.origin = target.global_transform.origin
			else:
				global_transform.origin = global_transform.origin.linear_interpolate(target.global_transform.origin, MOVESPEED)
		if mode == "lookat":
			global_transform = global_transform.interpolate_with(global_transform.looking_at(target.global_transform.origin, global_transform.basis.y), MOVESPEED)

func mission(_target: Object, _mode: String = "", multiplier : float = -1.0):
	if is_instance_valid(_target):
		
		emit_signal("unfollowed")
		if _target.has_method("follow_this"):
			_target.follow_this(self)
		else:
			target = _target
		if _mode != "":
			mode = _mode
		if multiplier != -1.0:
			followMultiplier = multiplier
		if _mode == "child":
			get_parent().call_deferred("remove_child",self)
			target.call_deferred("add_child",self)
		active = true

func uncouple():
	active = false


