extends MiniGame

export var interval = 1.4
export var intervalVariance = 1.2
export var upTime = 1.2
export var upTimeVariance = .2
export(Array, String) var inputNames

onready var timer = $Timer

var holes = [] #holes append themselves into this
var hitted = false

func _ready():
	fishLives = fishData["fishLives"]
	hookLives = hookData.hookLives
	randomize()
	timer.connect("timeout", self, "popup_hole")

func popup_hole():
	var randhole = randi() % holes.size()
	var maxtries = 0
	while holes[randhole].up && maxtries < 24:
		randhole = randi() % holes.size()
		maxtries += 1
	var randHole = holes[randhole]
	randHole.thisHoleInput = HelperScripts.random_value_from_array(inputNames)
	randHole.popup_mole(upTime + ((randf()-0.5) * upTimeVariance)) 
	timer.start(interval + ((randf() - 0.5) * intervalVariance))

func hit(): #called by holes when succesful hit
	fish_hit(1)
	
func missed():
	fish_miss(1)


