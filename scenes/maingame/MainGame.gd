extends Spatial

var currentWorld = null
const mainMenuScene = preload("res://scenes/ui/mainmenu/MainMenu.tscn")

func _ready():
	to_main_menu()

func to_main_menu():
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.play("fade_in")
	clear_add_node()
	var mainMenu = mainMenuScene.instance()
	mainMenu.connect("new_game", self, "start_game", [0])
	mainMenu.connect("continew", self, "start_game", [1])
	add_to_addnode(mainMenu)

func start_game(flag):
	$AnimationPlayer.play("fade_out")
	yield($AnimationPlayer,"animation_finished")
	if flag == 1:
		load_game()
	if flag == 0:
		start_new_game()

func clear_add_node():
	for node in $AddNode.get_children():
		node.queue_free()

func load_game():
	$SaveLoadNode.quick_load()

func start_new_game():
	$SaveLoadNode.start_new_game()

func add_to_addnode(node):
	$AddNode.add_child(node)

func _on_SaveLoadNode_world_out(world):
	clear_add_node()
	currentWorld = world
	add_to_addnode(world)
	world.connect("world_loaded", self, "start_play")
	world.connect("back_to_menu", self, "to_main_menu")
	world.connect("world_dead", self, "clear_add_node")
	world.start_world()
#	yield(world, "world_loaded")
#	$AnimationPlayer.play("fade_in")

func _process(delta):
	if Input.is_action_just_pressed("save_game"):
		$SaveLoadNode.save_game()
	if Input.is_action_just_pressed("quick_load"):
		start_game(1)

func start_play():
	$AnimationPlayer.play("fade_in")
