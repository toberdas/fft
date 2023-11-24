extends Node2D
class_name MiniGame

export var DEBUG = false
var defaultHookData = preload("res://assets/resources/items/hookData.tres")

var fishData setget set_fish_data
var hookData setget set_hook_data

var fishLives
var hookLives

#control vars
enum STATE{INTRO, HOOK, PLAY, MISS, HIT, WIN, LOSE, OUTRO}
var currentState
var targetState

signal gameLost
signal gameWon

signal fish_hit
signal player_hit

func _ready():
	modulate = Color(1.0,1.0,1.0,0.0)
	if !fishData:
		var newFishData = FishData.new()
		newFishData.generate()
		set_fish_data(newFishData)
	if !hookData:
		set_hook_data(defaultHookData)
	currentState = STATE.INTRO
	targetState = STATE.INTRO
	if DEBUG:
		start_game()
	

func setup(fishdata, hookdata):
	set_fish_data(fishdata)
	set_hook_data(hookdata)

func set_colors(_color : Color):
	pass

func start_game():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0,1.0,1.0,1.0), 1.0)
	yield(tween,"finished")
	targetState = STATE.PLAY

func switch_state(targetstate):
	targetState = targetstate
	pass

func _physics_process(delta):
	currentState = targetState
	if currentState == STATE.INTRO:
		introScript()
	if currentState == STATE.PLAY:
		playScript(delta)
	if currentState == STATE.WIN:
		winScript()
	if currentState == STATE.LOSE:
		loseScript()
	if currentState == STATE.OUTRO:
		outroScript()


func playScript(_delta):
	pass
func introScript():
	pass
func winScript():
	pass
func loseScript():
	pass
func outroScript():
	pass

func fish_hit(dmg):
	fishLives -= dmg
	emit_signal("fish_hit", fishLives)
	if fishLives <= 0:
		win()

func fish_miss(dmg):
	hookLives -= dmg
	emit_signal("player_hit", hookLives)
	if hookLives <= 0:
		lose()

func win():
	targetState = STATE.OUTRO
	emit_signal("gameWon")
	set_process(false)
	exit_game()

func lose():
	targetState = STATE.OUTRO
	emit_signal("gameLost")
	set_process(false)
	exit_game()

func exit_game():
	yield(get_tree().create_timer(1.0),"timeout")
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0,1.0,1.0,0.0), 0.5)
	yield(tween,"finished")
	queue_free()

func set_fish_data(val):
	fishData = val
	fishLives = fishData.fishLives
	set_colors(fishData.color)

func set_hook_data(val):
	hookData = val
	hookLives = hookData.hookLives
