extends Spatial

var walkDict = {}
var stepLength = 4

var platformArray = []


var islandJumpScale = 4
var islandScale = 6

export(PackedScene) var platScene

func run():
	randomize()
	for plat in platformArray:
		plat.queue_free()
	platformArray = []
	var w = Walk.new(stepLength, islandJumpScale, islandScale)
	w.connect("point_added", self, "add_platform")
	w.run()
	
func branch_walk(oldDict):
	Walk.new(stepLength, islandJumpScale, islandScale)

func add_platform(point):
	var p = platScene.instance()
	add_child(p)
	p.global_transform.origin = point.islandSpacePosition
	platformArray.append(p)
