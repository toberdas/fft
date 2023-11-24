extends Spatial ##the component that lets player interact with this thing in the 3d world

export(NodePath) var mesh 
export(Shape) var shape

var interactScene = null

signal interact_opened
signal interact_closed

func _ready():
	setup()

func setup():
	if shape:
		set_collision_shape()
	
func set_collision_shape():
	$Area/CollisionShape.shape = shape

func interact_opened(player = null):
	if player:
		emit_signal("interact_opened", player)
	else:	
		emit_signal("interact_opened")

func interact_closed(player = null):
	if player:
		emit_signal("interact_closed", player)
	else:
		emit_signal("interact_closed")
	interactScene = null
