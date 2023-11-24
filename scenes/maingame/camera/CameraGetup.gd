extends Follower
class_name CameraGetup 

var camInput = Vector2(0,0)
var followInput = Vector2.ZERO

export(NodePath) var point = null
export(String) var camName = ""

func _ready():
	GlobalSingleton.register_node(self)
	if point:
		point = get_node(point)

func _process(delta):
	if active:
		get_input()
		move_camera(delta)

func move_camera(_delta): #this method is set by inheritors
	pass

func get_input(): #input getter
	camInput = Vector2(0,0)
	camInput.x = Input.get_action_strength("camright") - Input.get_action_strength("camleft")
	camInput.y = Input.get_action_strength("camdown") - Input.get_action_strength("camup")
	camInput = camInput.normalized()

func follow_this(follower): #if a follower starts following this getup, this funciton is called
	if point is NodePath:
		point = get_node(point)
	if point:
		follower.target = point #if there is a point you would want the follower to follow instead set that as the follows follow
	active = true #switch to active
	follower.connect("unfollowed", self, "go_inactive", [], 4) #connect to the followers unfollowed signal, that is called when it disconnects, also disconnect from the signal when it is called

func go_inactive(): #when unfollowed set active to false, making it so this getup doesnt move when not followed
	if active:
		active = false
