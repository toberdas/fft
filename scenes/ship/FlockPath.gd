extends Path
class_name FlockPath

var count = 0
export(Resource) var moveResource


func add_to_flock(fish : Fish):
	fish.clear_movers_rigorous()
	var moverInstance = MoverInstance.new()
	moverInstance.moverResource = moveResource
	moverInstance.body = $PathFollow/FlockFollow
	moverInstance.time = moveResource.time
	fish.add_mover(moverInstance)
	count += 1
	return count
