extends CameraGetup #the interactscene conducts all action during interacting.

var interactable = null
var interactableComponent = null
var player = null

onready var focalPoint = $FocalPoint
onready var mouse = $"2DPointer"

var highlightedNode = null #keep track of what node you are hovering with the cursor
signal scene_open_start
signal scene_closed
signal scene_close_started

var txrot = 0.0
var tyrot = 0.0

var interactPlaceSpatial = null
var interactPlace = Vector3(0,1000,0)

var started = false
var closing = false

func init(_interactable, _interactableComponent):
	interactable = _interactable
	interactableComponent = _interactableComponent
	interactableComponent.interact_opened(player)
	interactableComponent.interactScene = self 
	interactPlaceSpatial = Spatial.new()
	interactable.get_parent().add_child(interactPlaceSpatial)
	interactPlaceSpatial.global_transform.origin = interactable.global_transform.origin
	interactable.set("interactScene", self)
	
func start():
	var trans = ScreenTransition.new()
	add_child(trans)
	trans.transition_start()
	yield(trans, "transition_started")
	emit_signal("scene_open_start")
	
	interactable.global_transform.origin = interactPlace
	interactable.set_as_toplevel(true)
	global_transform.origin = interactPlace
	
	yield(trans,"transition_done")
	started = true
	$"2DPointer".visible = true
	
func _process(delta):
	if interactable && started:
		var xrot = Input.get_action_strength("camright") - Input.get_action_strength("camleft")
		var yrot = Input.get_action_strength("camup") - Input.get_action_strength("camdown")
		txrot = lerp(txrot, xrot, 10 * delta)
		tyrot = lerp(tyrot, yrot, 10 * delta)
		interactable.rotate(Vector3.UP, txrot * delta * 1)
		interactable.rotate(Vector3.RIGHT, tyrot * delta * 1)
		if Input.is_action_just_pressed("cancelinteract"):
			close_scene()

func close_scene():
	if !closing:
		interactableComponent.interact_closed(player)
		closing = true
		var trans = ScreenTransition.new()
		add_child(trans)
		trans.transition_start()
		yield(trans, "transition_started")
		emit_signal("scene_close_started")
		interactable.set_as_toplevel(false)
		interactable.global_transform.origin = interactPlaceSpatial.global_transform.origin
		interactPlaceSpatial.queue_free()
		interactable.set("interactScene", null)
		
		yield(trans, "transition_done")
		emit_signal("scene_closed")
		free_scene()

func free_scene():
	queue_free()
	
	
