extends Spatial

export(PackedScene) var interactScene

var areaMap = {}

signal interacted
signal interaction_cancelled
signal cam_to_interact
signal cam_to_player

var currentScene = null
var heldInteract = null
var heldInteractComponent = null


func _on_Player_playeraction():
	var collar = $InteractArea.get_overlapping_areas()
	var coll = null
	if collar.size()>0:
		coll = collar[0]

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

		emit_signal("cam_to_interact", currentScene)
		emit_signal("interacted")
		


func scene_end_start():
	emit_signal("cam_to_player")

func scene_ended():
	heldInteract = null
	emit_signal("interaction_cancelled") ##sent to player to resume idle state

func _on_InteractArea_area_entered(area):
	if !areaMap.has(area):
		var instance = ThreeDPrompt.prompt(ThreeDPrompt.xboxInputs.b, area.global_transform.origin)
		area.add_child(instance)
		areaMap[area] = instance

func _on_InteractArea_area_exited(area):
	if areaMap.has(area):
		areaMap[area].queue_free()
		areaMap.erase(area)
