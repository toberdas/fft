extends Spatial
class_name NotePlayer

var bus = "Master"
var channelCount = 12
var channels = []
var channels3D = []
var ind = 0

var sample_hz = 22050.0 # Keep the number of samples to mix low, GDScript is not super fast.
var pulse_hz = 440.0
var phase = 0.0

var playback

signal note_played

func _init():
	for _i in range(channelCount):
		var aus = AudioStreamPlayer.new()
		add_child(aus)
		channels.append(aus)
	for _i in range(channelCount):
		var aus = AudioStreamPlayer3D.new()
		add_child(aus)
		channels3D.append(aus)

func run(position, dynamic, tonic, dist, scale, instrument, spatial):
	var startIntervalSum = scale.get_interval_sum(tonic, abs(position), sign(position))
	var nextIntervalSum = scale.get_interval_sum(position, abs(dist), sign(dist))
	var nextScale = pow(scale.exponent, startIntervalSum + nextIntervalSum)
	var plr
	if spatial:
		plr = channels3D[ind]
#		plr = AudioStreamPlayer3D.new()
		plr.unit_db = (-80.0 + (60 * dynamic)) + 20 * dynamic
	else:
		plr = channels[ind]
#		plr = AudioStreamPlayer.new()
		plr.volume_db = (-80.0 + (60 * dynamic)) + 20 * dynamic
#	add_child(plr)
	plr.stream = instrument.audio
	plr.pitch_scale = max(0.01, nextScale)
	plr.bus = bus
	plr.play(0.0)
	if ind < channelCount - 1:
		ind += 1
	else:
		ind = 0
	emit_signal("note_played")
#	plr.connect("finished", plr, "queue_free")

func run_alt(position, dynamic, tonic, dist, scale, instrument, spatial):
	var intSum = scale.get_interval_sum(position, abs(dist), sign(dist))
	pulse_hz = pow(scale.stepTonic + intSum, scale.exponent)
	emit_signal("note_played")

	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = AudioStreamGenerator.new()
	player.stream.mix_rate = sample_hz # Setting mix rate is only possible before play().
	playback = player.get_stream_playback()
	_fill_buffer(playback) # Prefill, do before play() to avoid delay.
	player.play()
	var tim = get_tree().create_timer(0.04).connect("timeout", player, "queue_free")


#
func _fill_buffer(playback):
	var increment = pulse_hz / sample_hz

	var to_fill = playback.get_frames_available()
	while to_fill > 0:
		playback.push_frame(Vector2.ONE * sin(phase * TAU)) # Audio frames are stereo.
		phase = fmod(phase + increment, 1.0)
		to_fill -= 1

