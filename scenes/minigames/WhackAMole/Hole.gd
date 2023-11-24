extends Node2D

onready var hole = $HoleSprite
onready var mole = $HoleSprite/Mole
onready var downNode = $HoleSprite/DownNode
onready var upNode = $HoleSprite/UpNode

var up = false
export(String) var thisHoleInput = "x" setget set_hole_input

signal mole_hit
signal mole_missed

func _ready():
	get_parent().holes.append(self)
	var _err = connect("mole_hit", get_parent(), "hit")
	_err = connect("mole_missed", get_parent(), "missed")
	$HoleSprite/Mole/MoleSprite/Label.text = thisHoleInput.to_upper()

func popup_mole(uptime):
	up = true
	yield(get_tree().create_timer(uptime), "timeout")
	up = false

func _process(delta):
	if up:
		mole.position = lerp(mole.position, upNode.position, 10 * delta)
	if !up:
		mole.position = lerp(mole.position, downNode.position, 10 * delta)

func _unhandled_input(event):
	if up:
		if Input.is_action_pressed(thisHoleInput):
			emit_signal("mole_hit")
			up = false
		else:
			emit_signal("mole_missed")

func set_hole_input(val):
	thisHoleInput = val
	$HoleSprite/Mole/MoleSprite/Label.text = thisHoleInput.to_upper()
