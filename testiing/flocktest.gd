extends Test
onready var flock = $Path/PathWalker/Flock
onready var path_walker = $Path/PathWalker

func test1():
	var save = FlockSave.new()
	save.sceneName = "Flock"
	save.loadDistance = 200
	save.targetPoint = HelperScripts.random_vec2()
	save.point = Vector2.ZERO
	save.flockSeed = hash(randf())
	flock.init(save)
	path_walker.auto = true
	
