extends Spatial

var rumbleVolume = 0.0
var revupVolume = 0.0
var maxRumbleVolume = 40.0
var maxRevupVolume = 70.0
var rev = 0.0
var revTarget = 0.0
var rumbleTarget = 0.0
var revDif = 0.0

func _process(delta):
	revDif = lerp(revDif, 0.0, 0.0001)
	rev = lerp(rev, 0.0, 0.001)
	revTarget = lerp(revTarget, rev, delta * 0.1)
	revupVolume = lerp(revupVolume, revTarget, 0.1)
	rumbleVolume = lerp(rumbleVolume, rumbleTarget - revTarget, 0.1)
	
	set_volumes()

func get_speed(oldspeed, newspeed):
	set_rumble(newspeed)
	calculate_revup(oldspeed, newspeed)

func set_rumble(newspeed):
	newspeed = abs(newspeed)
	rumbleTarget = newspeed

func calculate_revup(oldspeed, newspeed):
	var cdif = abs(oldspeed - newspeed)
	if cdif > revDif:
		revDif = cdif
		rev = 1.0

func set_volumes():
	var revVol = -80.0 + (revupVolume * (80.0 + maxRevupVolume))
	var rumbVol = -80.0 + (rumbleVolume * (80.0 + maxRumbleVolume))
	$EngineRevUp.unit_db = revVol
	$EngineRumble.unit_db = rumbVol
