extends PathWalker

export(NodePath) var follower ##if this is set, will only step if this node hits the pathwalker
export(int) var maskBit = 2 

var bodyHit = null

signal area_entered
signal body_entered

func _ready():
	target = get_parent().get_curve().get_baked_length()
	$Area.collision_mask = maskBit
	if follower: follower = get_node(follower)

func _process(delta):
	if follower:
		if $Area.overlaps_body(follower):
			walk_path(delta)



func _on_Area_area_entered(area):
	emit_signal("area_entered", area)


func _on_Area_body_entered(body):
	bodyHit = body
	emit_signal("body_entered", body)
