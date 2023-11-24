extends Spatial

var fraction = 0.0
var noise = null
var position = 0.0
var movementCount = 0
var movementLength = 16
var waitTime = 0
var waitTimeModifier = 1.0
var rythmResource = null
var totalInstrument = null
var music = null

signal hit_note

onready var timer = $Timer

func init(fract, _music, totins):
	fraction = fract
	music = _music
	totalInstrument = totins

	noise = OpenSimplexNoise.new()
	movementLength = totalInstrument.movementLength
	waitTime = 60.0 / music.BPM * fraction
	
func _ready():
	timer.wait_time = waitTime * waitTimeModifier
	timer.connect("timeout", self, "beat")

func beat():
	if position < totalInstrument.movementLength:
		position += fraction
	else:
		position -= totalInstrument.movementLength
		position += fraction
		if movementCount < music.movements:
			movementCount += 1
		else:
			movementCount = 0
	var rat = position/float(totalInstrument.movementLength)
	var n = 0.0
	if music.noiseTex:
		var ntex = music.noiseTex
		n = (ntex.noise.get_noise_2d(rat * ntex.width, movementCount)  + 1.0) / 2.0
	else:
		n = (noise.get_noise_1d(rat)  + 1.0) / 2.0
	var cp = float(rat)
	var co = totalInstrument.cutoffCurve.interpolate_baked(cp)
	var vr = randf() * totalInstrument.volatility
#	print_debug(music.resource_name + ": " + str(fraction) + ". cutoff: " + str(music.noiseCutoff) + ". noise: " + str(n) + ". vola: " + str(vr))
	
	if n + vr  > co:
		emit_signal("hit_note", rat)
	timer.wait_time = waitTime + rand_range(0 , totalInstrument.swing)
	timer.start()

func start():
	timer.start()
	timer.one_shot = true
