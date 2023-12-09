extends Follower #follows player, is the node that communicates between player and angle activity, also the node that runs the globalevents connected to baiting, hooking and catching fish

export(PackedScene) var predicting
export(PackedScene) var casting
export(PackedScene) var reelin

var castResource : CastResource setget set_cast_resource

var predictNode = null
var castNode = null
var reelinNode = null

enum ANGLESTATE{IDLE,PREDICTING,CASTING,WAITING,REELIN,RESET,NIBBLE,HOOKED,ADMIRE}

var state = ANGLESTATE.IDLE
var targetState = ANGLESTATE.IDLE
var predictTime = 0
var curve = preload("res://assets/curves/test_curve2.tres")
var slopecurve = preload("res://assets/curves/cur_downslope.tres")
var caughtFish = null


signal predict_cancelled
signal reeled_in
signal cast_freed

func _ready():
	start_predict()
	
func _process(_delta):
	state = targetState
	if state == ANGLESTATE.PREDICTING:
		if Input.is_action_just_released("cast"):
			start_cast()
		if Input.is_action_just_released("aligncam"):
			cancel_cast()
	if state == ANGLESTATE.CASTING:
		if Input.is_action_just_released("aligncam"):
			cancel_cast()
	if state == ANGLESTATE.RESET:
		if is_instance_valid(castNode):
			if castNode.reel_in(0.2):
				emit_signal("reeled_in")
				castNode.queue_free()
		if is_instance_valid(predictNode):
			emit_signal("predict_cancelled")
			predictNode.queue_free()
		free_cast()
			
func start_predict():
	predictNode = predicting.instance()
	predictNode.castResource = castResource
	add_child(predictNode)
	targetState = ANGLESTATE.PREDICTING

func start_cast():
	castNode = casting.instance()
	castNode.castResource = castResource
	add_child(castNode)
	castNode.start_cast(predictNode.predictDict)
	targetState = ANGLESTATE.CASTING
	predictNode.queue_free()

func cancel_cast():
	targetState = ANGLESTATE.RESET

func free_cast(_f = null):
	emit_signal("cast_freed", self)
	queue_free()

func hook_fish(fish): #this is run when you engage a nibble
	reelinNode = reelin.instance()
	reelinNode.castResource = castResource
	add_child(reelinNode)
	reelinNode.start(fish, castNode.lineArray)
	targetState = ANGLESTATE.HOOKED
	castNode.queue_free()
	fish.hooked(self.get_parent()) #run the fish's hooked method, telling it it got hooked and what it got hooked to! use the angle node for this, as the bobber will be freed after hooking

func set_cast_resource(nr : CastResource):
	castResource = nr
	castResource.connect("fish_hooked", self, "hook_fish")
	castResource.connect("cast_stopped", self, "queue_free")
