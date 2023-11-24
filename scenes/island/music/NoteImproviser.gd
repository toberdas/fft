extends Spatial

var sscale = null
var instrument = null
var totalIns = null
var music = null
var bus = "Master"
var tonic = 440
var currentTone = 440
var currentPos = 0
var distFromTonic = 0
var intervalsFromTonic = 0
var noise = null
var distance = 0

var flatDecibelAdd = 0

func init(_music, totalins, _bus):
	bus = _bus
	music = _music
	totalIns = totalins
	noise = OpenSimplexNoise.new()
	sscale = _music.scale
	tonic = totalIns.soundTone * totalIns.toneScale
	currentTone = tonic
	currentPos = 0
	
func run(p):
	var dist = randi() % 3
#	var dir = int(sign(rand_range(-1.0,1.0)))
#	var dist = int(ceil(noise.get_noise_1d(float(p)) * 40))
	var dir = int(sign(rand_range(-1.5,1.5)))
	var intSum = sscale.get_interval_sum(currentPos, dist, dir)
	while abs(intervalsFromTonic + intSum) > totalIns.intervalRange:
		dist = randi() % 3
		dir = int(sign(rand_range(-1.5,1.5)))
		
		intSum = sscale.get_interval_sum(currentPos, dist, dir)
	var t = new_tune(intSum, dir, dist)
	play_note(t, p)

func new_tune(intervals, dir, dist):
	intervalsFromTonic += intervals
	currentTone = currentTone * pow(sscale.exponent, intervals)
	currentPos += dist * dir % sscale.intervals.size()
	distFromTonic += dist * dir
#	distance += 1
#	distance = distance % totalIns.movementLength
	var tscale = currentTone / tonic
	
	return tscale
	
func play_note(tscale, p):
	var ci = totalIns.curveDynamic.interpolate(p)
	var rat = music.dynamicFalloffCurve.interpolate(get_parent().distRat)
	rat *= ci
	var plr
	if music.spatial:
		plr = AudioStreamPlayer3D.new()
		plr.unit_db = (-80.0 + (60 * rat)) + 20 * ci + flatDecibelAdd
	else:
		plr = AudioStreamPlayer.new()
		plr.volume_db = (-80.0 + (60 * rat)) + 20 * ci + flatDecibelAdd
	add_child(plr)
	plr.stream = totalIns.sound
	plr.pitch_scale = max(0.01, totalIns.toneScale + (1.0 - tscale))
	plr.bus = bus
	plr.play(0.0)
	plr.connect("finished", plr, "queue_free")

