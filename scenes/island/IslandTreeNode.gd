extends Spatial

var storedResource = null
export(NodePath) var dialogNode

signal ask_for_load

func _ready():
	dialogNode = get_node(dialogNode)
		
func add_island(islandInstance):
	add_child(islandInstance)
	
	var statbod = islandInstance.get_node_or_null("StaticBody")
	if statbod:
		if !statbod.get_script():
			statbod.set_script(load("res://scenes/island/StepOnable.gd"))
		statbod.connect("stepped_on", dialogNode, "player_entered_island", [], 4)
		
	var fishman = islandInstance.get_node_or_null("FishManager")
	if fishman:
		fishman.connect("propagate_fish_caught", dialogNode, "fish_caught") 

func unload_island():
	var statbod = storedResource.get_node_or_null("StaticBody")
	if statbod:
		if statbod.is_connected("stepped_on", dialogNode, "player_entered_island"):
			statbod.disconnect("stepped_on", dialogNode, "player_entered_island")
	var fishman = storedResource.get_node_or_null("FishManager")
	if fishman:
		fishman.disconnect("propagate_fish_caught", dialogNode, "fish_caught") 
	remove_child(storedResource)
	
func _on_IslandNode_start_initialize(islandresource, _player):
	if storedResource == null:
		if islandresource:
			if islandresource.islandScenePath:
				emit_signal("ask_for_load", islandresource.islandScenePath)
	else:
		add_island(storedResource)

func _on_IslandLoader_load_done(islandInstance):
	if islandInstance:
		add_island(islandInstance)
		storedResource = islandInstance

func _on_IslandNode_start_deinitialize():
	pass
#	unload_island()
