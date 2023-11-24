extends Test

func test1():
	var fishdat = FishData.new()
	fishdat.generate()
	var item = ItemData.make_itemresource_from_fishdata(fishdat)
