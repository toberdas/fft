extends Test

export(Resource) var fishData
var testData

func test1():
	for i in range(1000):
		testData = FishData.new()
		testData.generate()
		print("done")
