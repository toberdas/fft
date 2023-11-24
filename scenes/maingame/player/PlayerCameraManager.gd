extends Node

var targetTimeScale = 1.0

const staticThirdPersonCamScene = preload("res://scenes/maingame/camera/StaticThirdPersonCamera.tscn")

export(NodePath) var fpscam
export(NodePath) var tpscam
export(NodePath) var rotcam
export(NodePath) var player
export(NodePath) var cam
export(NodePath) var camMount
export(NodePath) var tpspoint

func _ready():
	fpscam = get_node(fpscam)
	tpscam = get_node(tpscam)
	rotcam = get_node(rotcam)
	player = get_node(player)
	cam = get_node(cam)
	camMount = get_node(camMount)
	tpspoint = get_node(tpspoint)

func _on_CastManager_fish_hooked(fish):
	TimePiece.targetTimeScale = 1.0
#	fpscam.mission(player)
#	fpscam.global_transform = player.global_transform
#	fpscam.activate(fish.get_node("HeadPoint").global_transform.origin)
#	camMount.mission(fpscam, "transform")
	camMount.mission(tpscam, "transform")
	player.targetState = player.state.reelin

func _on_CastManager_nibble(fish):
	camMount.mission(fish, "lookat")
	TimePiece.targetTimeScale = 0.1

func _on_CastManager_ignore_nibble(_fish):
	camMount.mission(tpscam, "transform")
	TimePiece.targetTimeScale = 1.0

func _on_CastManager_fish_lost(_fish):
	tpscam.mission(tpspoint)
	camMount.mission(tpscam, "transform", 1.0)
	player.targetState = player.state.idle
	cam.targetFOV = 70

func start_play():
	TimePiece.targetTimeScale = 1.0
	cam.targetFOV = 5

func release_fish():
	TimePiece.targetTimeScale = 1.0
	fpscam.target = null #set to null so fpspivot cant rotate player on accident
	cam.targetFOV = 50
	
	yield(get_tree().create_timer(2), "timeout") #after a second, so you can watch the fish swim away a bit
	tpscam.target = tpspoint
	camMount.mission(tpscam, "transform", 1.0)
	rotcam.mission(player)
	cam.targetFOV = 70
	player.targetState = player.state.idle

func done_gaming():
	rotcam.set_rotator_params({targetSpeed = 0.3})
	fpscam.target = null #set to null so fpspivot cant rotate player on accident #FIND A WORKAROUND!
	player.targetState = player.state.idle
	cam.targetFOV = 70
	
	rotcam.set_rotator_params({targetSpeed = 0.1})
	
	yield(get_tree().create_timer(1), "timeout")
	rotcam.set_rotator_params({targetSpeed = 3})
	tpscam.mission(tpspoint)
	camMount.mission(tpscam, "transform", 0.5)
	cam.targetFOV = 70
	
	yield(get_tree().create_timer(1), "timeout")
	camMount.mission(tpscam, "transform", 1.0)
	rotcam.mission(player)

func slight_zoom():
	cam.targetFOV = 60

func reset_cam():
	cam.targetFOV = 70
	TimePiece.targetTimeScale = 1.0
	camMount.mission(tpscam, "transform", 1.0)

func go_fps():
	fpscam.mission(player)
	fpscam.global_transform = player.global_transform
	fpscam.activate(player.global_transform.origin - player.global_transform.basis.z * 10.0)
	camMount.mission(fpscam, "transform")

func _on_PlayerInteracter_cam_to_interact(_interactscene):
	camMount.mission(_interactscene, "transform", 4.0)

func _on_PlayerInteracter_cam_to_player():
	camMount.mission(tpscam, "transform", 4.0)

func _on_CatchNode_release_fish():
	release_fish()

func _on_CatchNode_start_play():
	start_play()

func _on_CatchNode_brokefree():
	release_fish()

func _on_CatchNode_caught(_fish):
	done_gaming()

func _on_CastManager_cast_cleared():
	reset_cam()

func _on_CatchNode_fish_netted(fish):
	TimePiece.targetTimeScale = 0.1
	rotcam.mission(fish)
	camMount.mission(rotcam, "transform", 0.7)
	cam.targetFOV = 50

func _on_CastManager_thrown():
	slight_zoom()


func _on_InvestigatingNode_start_investigating():
	go_fps()


func _on_InvestigatingNode_stop_investigating():
	reset_cam()


func _on_Player_fly_start():
	tpscam.mission(GlobalSingleton.ship.get_node("CameraPoint"), "transform", 0.7)
	camMount.mission(tpscam)


func _on_Player_fly_end():
	tpscam.mission(tpspoint, "origin", 0.7)
	camMount.mission(tpscam)
