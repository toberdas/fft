extends Spatial
export(bool) var autoplay =false
export(Resource) var myMusic
export(PackedScene) var instrumentSpeler
export(PackedScene) var rythmNode
export(String) var bus = "Master"

var bass = null
var lead = null
var distRat = 0.0
var rythmNodes = []
var myPlayer = null

func _ready():
	if autoplay:
		start()

func start(music = null):
	if music: 
		myMusic = music
	myMusic.scale = Scale.new()
	myMusic.scale.generate()
	for totins in myMusic.totalInstruments:
		myPlayer = add_instrument_player(totins)
		for fract in totins.fractionArray:
			var rn = add_rythm_node(fract, totins)
			rn.connect("hit_note", myPlayer, "run")
			rythmNodes.append(rn)
	
	for r in rythmNodes:
		r.start()
		
func add_instrument_player(totins):
	var pl = instrumentSpeler.instance()
	add_child(pl)
	pl.init(myMusic, totins, bus)
	return pl

func add_rythm_node(fract, totins):
	var rythnode = rythmNode.instance()
	rythnode.init(fract, myMusic, totins)
	add_child(rythnode)
	return rythnode

func stop():
	for child in get_children():
		child.queue_free()
		rythmNodes.clear()
	pass

func update_music(distrat):
	distRat = distrat

func set_rythm_time_modifier(newModifier):
	for rythmNode in rythmNodes:
		rythmNode.waitTimeModifier = newModifier

func set_flat_decibel_add(newAdd):
	myPlayer.flatDecibelAdd = newAdd
