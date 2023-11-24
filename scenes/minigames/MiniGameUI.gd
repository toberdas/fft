extends Control

export(NodePath) var textLabel
export(NodePath) var lifeControl
export(NodePath) var fishLives
export(NodePath) var playerLives

signal ui_done
signal text_done
signal game_done

var minigameResource

func _ready():
	if textLabel:
		textLabel = get_node(textLabel)
	if lifeControl:
		lifeControl = get_node(lifeControl)
	fishLives = get_node(fishLives)
	playerLives = get_node(playerLives)

func intro_game(_minigameResource : MiniGameResource, _playerdata, _fishdata):
	fishLives.text = str(_fishdata["fishLives"])
	playerLives.text = str(_playerdata["hookLives"])
	minigameResource = _minigameResource
	
	if !minigameResource.played:
		textLabel.set_text("Let's play " + minigameResource.name + " " + minigameResource.tutorialText)
		minigameResource.played = true
	else:
		textLabel.set_text("Let's play " + minigameResource.name)
	
	var tween = create_tween()
	tween.tween_property(textLabel, "modulate", Color(1.0,1.0,1.0,1.0), .1)
	tween.tween_property(lifeControl, "modulate", Color(1.0,1.0,1.0,1.0), 1)

	yield(textLabel, "done_typing")
	emit_signal("text_done")
	
	yield(get_tree().create_timer(1.5),"timeout")
	tween = create_tween()
	tween.tween_property(textLabel, "modulate", Color(1.0,1.0,1.0,0.0), .3)
	emit_signal("ui_done")

func exit_game(_result):
	if _result == 1:
		textLabel.set_text(minigameResource.winText)
	else:
		textLabel.set_text(minigameResource.loseText)
	
	var tween = create_tween()
	tween.tween_property(textLabel, "modulate", Color(1.0,1.0,1.0,1.0), .5)
	
	yield(textLabel, "done_typing")
	
	yield(get_tree().create_timer(1.4),"timeout")
	tween = create_tween()
	tween.tween_property(textLabel, "modulate", Color(1.0,1.0,1.0,0.0), 2)
	tween.tween_property(lifeControl, "modulate", Color(1.0,1.0,1.0,1.0), 2)
	
	yield(tween,"finished")
	emit_signal("ui_done")

func fish_hit(_fishlives):
	fishLives.text = str(_fishlives)

func player_hit(_playerlives):
	playerLives.text = str(_playerlives)
