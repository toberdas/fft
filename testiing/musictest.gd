extends Node


var scale = null
var pos = 0
export(Resource) var instrument

# Called when the node enters the scene tree for the first time.
func _ready():
	new_scale()

func new_scale():
	randomize()
	scale = Scale.new()
	pos = 0

func _process(delta):
	if Input.is_action_just_pressed("action"):
		new_scale()
	if Input.is_action_just_pressed("ui_up"):
		play_note_up()
	if Input.is_action_just_pressed("ui_down"):
		play_note_down()

func play_note_up():
	$NotePlayer.run(pos, 1.0, scale.tonic,1,scale,instrument, false)
	pos += 1

func play_note_down():
	$NotePlayer.run(pos, 1.0, scale.tonic,-1,scale,instrument, false)
	pos -= 1
