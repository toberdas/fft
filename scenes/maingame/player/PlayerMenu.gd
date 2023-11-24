extends Menu

onready var mapScene = preload("res://scenes/ui/MapScene.tscn")
onready var fishtalkScene = preload("res://scenes/maingame/player/PlayerFishTalkManager.tscn")

var map
var fishtalk

#func _ready():
#	fishtalk = add_instance_from_scene_with_name(fishtalkScene, "fishtalk")
#	map = add_instance_from_scene_with_name(mapScene, "map")
	
func _process(delta):
	if open:
		if Input.is_action_just_pressed("cycle_menu_right"):
			cycle_key(1)
		if Input.is_action_just_pressed("cycle_menu_left"):
			cycle_key(-1)

func _on_Player_menutoggle():
	toggle_menu()

func _on_PlayerInteracter_interaction_cancelled():
	close_menu()

func _on_Player_damaged(_player):
	close_menu()

func _on_PlayerIslandNode_island_point_out(point):
	pass #DOES NOTHING


func _on_PlayerIslandNode_savegame_out(savegame : SaveGame):
	map.saveGame = savegame
	set_instance_property("UpgradeCollectionScene", "upgradeCollection", savegame.upgradeCollectionResource)

