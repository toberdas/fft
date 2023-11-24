extends Follower #follows player, is the node that communicates between player and angle activity, also the node that runs the globalevents connected to baiting, hooking and catching fish

export(PackedScene) var predicting
export(PackedScene) var casting
export(PackedScene) var reelin

var castResource

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
#var equipDict = {}

signal throw
signal predict_cancelled
signal predict_succeeded
signal reeled_in
signal fish_hooked
signal fish_caught
signal fish_lost
signal nibble
signal ignore_nibble
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
	if state == ANGLESTATE.WAITING:
		if Input.is_action_just_released("aligncam"):
			cancel_cast()
		if Input.is_action_pressed("reelin"):
			if castNode.reel_in(0.1):
				emit_signal("reeled_in")
				castNode.queue_free()
				free_cast()
	if state == ANGLESTATE.RESET:
		if is_instance_valid(castNode):
			if castNode.reel_in(0.2):
				emit_signal("reeled_in")
				castNode.queue_free()
		if is_instance_valid(predictNode):
			emit_signal("predict_cancelled")
			predictNode.queue_free()
		free_cast()
	if state == ANGLESTATE.HOOKED:
		pass
	if state == ANGLESTATE.ADMIRE:
		if Input.is_action_pressed("x"):
			caughtFish.start_play()
#			GlobalSingleton.glob_start_play(caughtFish)
			free_cast()
		if Input.is_action_pressed("y"):
			caughtFish.release()
#			GlobalSingleton.glob_release_fish()
			free_cast()
			
func start_predict():
	predictNode = predicting.instance()
	predictNode.castResource = castResource
	add_child(predictNode)
	targetState = ANGLESTATE.PREDICTING

func start_cast():
	emit_signal("throw")
	castNode = casting.instance()
	castNode.castResource = castResource
	add_child(castNode)
	castNode.start_cast(predictNode.predictDict)
	castNode.connect("fishhooked", self, "hook_fish")
	castNode.connect("nibble", self, "nibble")
	castNode.connect("reeledin", self, "free_cast")
	castNode.connect("ignore_nibble", self, "ignore_nibble")
	targetState = ANGLESTATE.CASTING
	emit_signal("predict_succeeded")
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
	reelinNode.connect("reel_succes", self, "fish_caught")
	reelinNode.connect("reel_fail", self, "free_cast")
	reelinNode.connect("reel_fail", self, "fish_lost")
	targetState = ANGLESTATE.HOOKED
	castNode.queue_free()
	emit_signal("fish_hooked", fish)

	fish.hooked(self.get_parent()) #run the fish's hooked method, telling it it got hooked and what it got hooked to! use the angle node for this, as the bobber will be freed after hooking

func _on_Casting_castdone():
	targetState = ANGLESTATE.WAITING

func nibble(fish):
	emit_signal("nibble", fish)
func ignore_nibble(fish):
	emit_signal("ignore_nibble", fish)
func fish_caught(fish):
	emit_signal("fish_caught", fish)
	queue_free()
func fish_lost(fish):
	emit_signal("fish_lost", fish)
