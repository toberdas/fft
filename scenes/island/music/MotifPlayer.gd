extends Spatial
class_name MotifPlayer

var measureDuration = 1.0
var dynamicBase = 1.0
var durationVariance = 1.0
var startVariance = 1.0
var reverseVariance = 1.0
var durationSubtract = 0.0

var mute = 1.0

var notePlayer = null
var spatial = false

signal lastnote
signal measuredone

func _ready():
	notePlayer = NotePlayer.new()
	add_child(notePlayer)

func mute():
	mute = 0.0

func unmute():
	mute = 1.0

func _init(motifPlayerProperties = MotifPlayerProperties.new()):
	load_properties(motifPlayerProperties)

func load_properties(properties):
	spatial = properties.spatial
	dynamicBase = properties.dynamicBase
	durationVariance = properties.durationVariance
	startVariance = properties.startVariance
	reverseVariance = properties.reverseVariance
	durationSubtract = properties.durationSubtract

func play_motif(motif, inverse = false):
	if randf() > 1.0 - reverseVariance:
		inverse = true
	var ml = motif.bladmuziek.size()
	var j = 0
	measureDuration = .5 + (randf() * .5 * durationVariance) - durationSubtract
	for measure in motif.bladmuziek:
		var i = 0
		for note in measure:
			var t = abs((float(i) / float(ml) * measureDuration) + (j * measureDuration) - (float(inverse) * measureDuration))
			var tim = get_tree().create_timer(t)
			if note != null:
				tim.connect("timeout", self, "play_note", [note, motif.scale])
			if i == measure.size() - 1:
				if j == ml - 1:
					tim.connect("timeout", self, "emit_signal", ["lastnote"])
				else:
					tim.connect("timeout", self, "emit_signal", ["measuredone"])
			i += 1
		j += 1

func play_note(note, scale):
	notePlayer.run(int(2 * (randf() * startVariance)), (note.dynamic) * dynamicBase * mute, note.scale.tonic, note.interval, note.scale, note.instrument, spatial)


