extends Node
class_name Global

var defaultFOV
var targetTimeScale = 1.0
var globalDict = {}
var cam = null
var camMount = null
var player = null
var ship = null
var currentMap = null

var debug = true

func register_node(node):
	globalDict[node.name] = node

func _ready():
	GlobalSignals.connect_event("world_ready", self, self, "glob_start")
	

func glob_start():
#	defaultFOV = cam.fov
	globalDict["ThirdPersonCamGetup"].mission(globalDict["ThirdPersonCamPoint"])
	
func glob_nibble(fish):
	camMount.mission(fish, "lookat")
	targetTimeScale = 0.1

#func glob_ignore_nibble(fish):
#	camMount.mission(globalDict["ThirdPersonCamGetup"], "transform")
#	targetTimeScale = 1.0

func glob_hook(fish, _hook):
	targetTimeScale = 1.0
	globalDict["FirstPersonCamGetup"].mission(player)#because the fpspivot can only be attached when you are in fps mode, because of the way it handles rotation, set it to follow player every time you need it to be fps
	globalDict["FirstPersonCamGetup"].activate(fish.get_node("HeadPoint"))
	camMount.mission(globalDict["FirstPersonCamGetup"], "transform")
	player.targetState = player.state.reelin

#func glob_unhook(fish):
#	globalDict["ThirdPersonCamGetup"].mission(globalDict["ThirdPersonCamPoint"])
#	camMount.mission(globalDict["ThirdPersonCamGetup"], "transform", 1.0)
#	player.targetState = player.state.idle
#	cam.targetFOV = defaultFOV

func glob_catch(fish):
	globalDict["RotatingCamGetup"].mission(fish)
	camMount.mission(globalDict["RotatingCamGetup"], "transform", 0.7)
	cam.targetFOV = 50

func glob_start_play(_fish):
	cam.targetFOV = 5

func glob_release_fish():
	globalDict["FirstPersonCamGetup"].target = null #set to null so fpspivot cant rotate player on accident
	player.targetState = player.state.idle

	yield(get_tree().create_timer(2), "timeout") #after a second, so you can watch the fish swim away a bit
	globalDict["ThirdPersonCamGetup"].target = globalDict["ThirdPersonCamPoint"]
	camMount.mission(globalDict["ThirdPersonCamGetup"], "transform", 1.0)
	cam.targetFOV = defaultFOV

func glob_done_gaming(_fish):
	globalDict["RotatingCamGetup"].set_rotator_params({targetSpeed = 0.3})
	globalDict["FirstPersonCamGetup"].target = null #set to null so fpspivot cant rotate player on accident #FIND A WORKAROUND!
	player.targetState = player.state.idle
	cam.targetFOV = defaultFOV
	
	globalDict["RotatingCamGetup"].set_rotator_params({targetSpeed = 0.1})
	
	yield(get_tree().create_timer(1), "timeout")
	globalDict["RotatingCamGetup"].set_rotator_params({targetSpeed = 3})
	globalDict["ThirdPersonCamGetup"].mission(globalDict["ThirdPersonCamPoint"])
	camMount.mission(globalDict["ThirdPersonCamGetup"], "transform", 0.5)
	cam.targetFOV = defaultFOV
	
	yield(get_tree().create_timer(1), "timeout")
	camMount.mission(globalDict["ThirdPersonCamGetup"], "transform", 1.0)
	
func glob_interacted(_interactscene): #called from the playerinteracter when succesfully interacted with an interactable
	globalDict["ScreenTransition"].transition_start()
	yield(globalDict["ScreenTransition"], 'transition_started')
	camMount.mission(globalDict["InteractScene"], "transform", 2.0)
	#camMount.target = interactscene
	#cameraDict["InteractCam"].mission(interactscene, "transform", 1)

func glob_stop_interact():
	pass
#	globalDict["ScreenTransition"].transition_start()
#	yield(globalDict["ScreenTransition"], 'transition_started')
#	camMount.mission(globalDict["ThirdPersonCamGetup"], "transform", 2.0)

func _process(delta):
	if Engine.time_scale != targetTimeScale:
		Engine.time_scale = lerp(Engine.time_scale, targetTimeScale, 2 * delta)
