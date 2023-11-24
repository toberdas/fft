extends Test

var fishdata : FishData

func _ready():
	fishdata = FishData.new()
	fishdata.generate()

func test1():
	$FishFace.run(fishdata)


func test2():
	fishdata = FishData.new()
	fishdata.generate()
