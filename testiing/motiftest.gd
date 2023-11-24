extends Node

var scale = null
var motif = null


# Called when the node enters the scene tree for the first time.
func _ready():
	new_scale()
	new_motif()
	$MotifPlayer.dynamicBase = 1.0


func _process(delta):
	if Input.is_action_just_pressed("action"):
		new_motif()
	if Input.is_action_just_pressed("ui_up"):
		play_motif()
	if Input.is_action_just_pressed("ui_down"):
		new_scale()

func new_scale():
	scale = Scale.new()
	
func new_motif():
	motif = Motif.new(scale)


func play_motif():
	$MotifPlayer.play_motif(motif)
