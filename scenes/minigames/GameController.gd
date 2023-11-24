extends Control
class_name GameController

var fishData = null
var hookData = preload("res://assets/resources/items/hookData.tres") #default data
var index = 0
var fishHealth = 1
var rodHealth = 3
var minigameResource
var currentGameScene
var active = false

signal gamingdone

export(NodePath) var UI

const gameCollection = preload("res://assets/resources/minigames/MiniGameCollection.tres")

func _ready():
	var tween = create_tween()
	tween.tween_property($MarginContainer, "modulate", Color(1.0,1.0,1.0,1.0), 0.25)
	yield(tween,"finished")
	if UI:
		UI = get_node(UI)
#	if fishData:
#		gameCollection = gameCollection.games
#	else:
#		fishData = FishData.new()
#		fishData.generate()
#		gameCollection = gameCollection.games
	index = randi() % gameCollection.minigameResources.size()
	next_game()

func next_game():
	minigameResource = gameCollection.minigameResources[index] #get a dict with data about the game to be played from the minigame data singleton
	
	UI.intro_game(minigameResource, hookData, fishData)
	
	yield(UI, "text_done")
	currentGameScene = minigameResource.scene.instance()
	currentGameScene.setup(fishData, hookData)
	currentGameScene.connect("gameWon", self, "tally", [1])
	currentGameScene.connect("gameLost", self, "tally", [-1])
	currentGameScene.connect("fish_hit", UI, "fish_hit")
	currentGameScene.connect("player_hit", UI, "player_hit")	
	$MarginContainer/ViewportContainer/Viewport.add_child(currentGameScene)
	yield(get_tree().create_timer(0.2),"timeout")
	
	
	yield(UI, "ui_done")
	currentGameScene.start_game()

func tally(score):
	if score > 0:
		fishHealth -= score
		UI.exit_game(1)
	if score < 0:
		rodHealth -= score
		UI.exit_game(-1)
		
	yield(UI, "ui_done")
	if fishHealth > 0:
		index = randi() % gameCollection.minigameResources.size()
		next_game()
	else:
		emit_signal("gamingdone", 1) #emit signal with 1 as arg if you won
#		queue_free()
	
	if rodHealth == 0:
		emit_signal("gamingdone", -1) #emit signal with -1 as arg if you lost, this is done to be able to yield a single signal for the fishtalk node to wait for
#		queue_free()
