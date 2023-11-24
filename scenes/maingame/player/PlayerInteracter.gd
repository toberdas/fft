extends Spatial

export(PackedScene) var interactScene

onready var raycast = $RayCast

signal interacted
signal interaction_cancelled
signal cam_to_interact
signal cam_to_player

var currentScene = null
var heldInteract = null
var heldInteractComponent = null
#var interactOrigin = null

func _on_Player_playeraction():
	var coll = raycast.get_collider()
	if coll && interactScene && !heldInteract:
		currentScene = interactScene.instance()
		get_tree().get_root().add_child(currentScene)
		heldInteract = coll.owner.get_parent()
		heldInteractComponent = coll.owner
		currentScene.player = owner
		currentScene.init(heldInteract, heldInteractComponent) #initialize the interactscene, providing it the owner of the colliding body as a reference, which is the interactable itself
		currentScene.connect("scene_closed", self, "scene_ended")
		currentScene.connect("scene_close_started", self, "scene_end_start")
		currentScene.start()
		yield(currentScene, "scene_open_start")
#		heldInteractComponent.interact_opened(owner)
#		heldInteractComponent.interactScene = currentScene 
		emit_signal("cam_to_interact", currentScene)
		emit_signal("interacted")
		


func scene_end_start():
	emit_signal("cam_to_player")

func scene_ended():
#	heldInteractComponent.interact_closed(owner)
	heldInteract = null
#	heldInteractComponent = null
	emit_signal("interaction_cancelled") ##sent to player to resume idle state
