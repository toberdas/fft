extends Spatial

var motifPlayer = null
var myMotif = null

signal motif_ended
var playing = false

func _on_Fish_fishready(fish : Fish):
	myMotif = fish.fishData.motif

func _on_Fish_hooked(_fish):
	var hookedMotifProperties = MotifPlayerProperties.new(false, 1.0, 0.0, 1.0, 0.8, 0.3)
	play_motif(hookedMotifProperties)
	motifPlayer.connect("lastnote", self, "play_motif", [hookedMotifProperties])

func _on_Fish_start_play():
	var playMotifProperties = MotifPlayerProperties.new(false, 1.0, 2.0, 1.5, 1.0, -.3)
	play_motif(playMotifProperties)

func _on_Fish_brokefree():
	clear_motif_player()

func _on_Fish_caught(_fish):
	clear_motif_player()

func _on_FishSingNode_sing():
	var playMotifProperties = MotifPlayerProperties.new(true, 0.8, 0.5, 0.5, 0.5, 0.5)
	play_motif(playMotifProperties)

func play_motif(motifPlayerProperties = MotifPlayerProperties.new()):
	if !playing:
		if !motifPlayer:
			motifPlayer = MotifPlayer.new(motifPlayerProperties)
			add_child(motifPlayer)
			motifPlayer.play_motif(myMotif)
			motifPlayer.connect("lastnote", self, "motif_done")
		else:
			motifPlayer.load_properties(motifPlayerProperties)
			motifPlayer.play_motif(myMotif)
		playing = true

func motif_done():
	playing = false
	emit_signal("motif_ended")

func clear_motif_player():
	if motifPlayer:
		motifPlayer.queue_free()
	motifPlayer = null


func _on_TalkManager_ask_for_motif():
	var playMotifProperties = MotifPlayerProperties.new(false, 1.0, 2.0, 1.5, 1.0, -.3)
	play_motif(playMotifProperties)
