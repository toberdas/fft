extends Resource
class_name FishMeshCurveData

var startout
var endin

var shoulderPoint
var hipPoint
var shoulderIn
var shoulderOut
var hipIn
var hipOut

var nosePoint
var foreheadPoint
var backStartPoint
var backEndPoint
var tailNarrowPoint
var tailWidePoint
var tailEndPoint

var backPoint
var sidePoint
var bellyPoint
var sidePoint2
var backPoint2

func _init():
	generate_new()

func generate_new():
	shoulderPoint = random_shoulderpoint()
	hipPoint = random_hippoint()
	shoulderIn = random_shoulder_in()
	shoulderOut = -shoulderIn
	hipIn = random_hip_in()
	hipOut = -hipIn
	
	nosePoint = random_nose_point()
	foreheadPoint = random_forehead_point(nosePoint.y)
	backStartPoint = random_backstart_point()
	backEndPoint = random_backend_point()
	tailNarrowPoint = random_tail_narrow_point(backEndPoint.x)
	tailWidePoint = random_tail_wide_point(tailNarrowPoint.x)
	tailEndPoint = random_tail_end_point()
	
	backPoint = random_back_point()
	sidePoint = random_side_point()
	bellyPoint = random_belly_point()
	sidePoint2 = sidePoint
	sidePoint2.x = 0.75
	backPoint2 = backPoint
	backPoint2.x = 1.0

func mutate():
	var tiny = rand_range(-0.01,0.01)
	var small = rand_range(-0.1,0.1)
	var medium = rand_range(-0.2,0.2)
	var big = rand_range(-0.3,0.3)
	shoulderPoint += Vector3(tiny, tiny, small)
	hipPoint += Vector3(tiny, tiny, small)
	shoulderIn += Vector3(tiny,tiny,tiny)
	shoulderOut = -shoulderIn
	hipIn += Vector3(tiny,tiny,tiny)
	hipOut = -hipIn
	nosePoint += Vector2(tiny,tiny)
	foreheadPoint += Vector2(small, small)
	backStartPoint += Vector2(tiny, small)
	backEndPoint += Vector2(tiny, tiny)
	tailEndPoint += Vector2(small, big)
	backPoint.y += small
	backPoint2.y += small
	sidePoint.y += small
	sidePoint2.y += small
	bellyPoint.y += medium

func random_shoulderpoint():
	var x = rand_range(-0.1,0.1)
	var y = rand_range(-0.1, 0.1)
	var z = rand_range(-0.4,-0.3)
	return Vector3(x,y,z)

func random_hippoint():
	var x = rand_range(-0.1,0.1)
	var y = rand_range(-0.1, 0.1)
	var z = rand_range(0.3, 0.4)
	return Vector3(x,y,z)

func random_shoulder_in():
	var x = rand_range(-0.1,0.1)
	var y = rand_range(-.25, .25)
	var z = -.1
	return Vector3(x,y,z)

func random_hip_in():
	var x = rand_range(-0.1,0.1)
	var y = rand_range(-.25, .25)
	var z = -.1
	return Vector3(x,y,z)

func random_nose_point():
	var x = rand_range(0.0,0.05)
	var y = rand_range(0.1,0.4)
	return Vector2(x,y)

func random_forehead_point(miny = 0.2):
	var x = rand_range(0.10, 0.24)
	var y = rand_range(miny + 0.1, 1.0)
	return Vector2(x,y)
	
func random_backstart_point():
	var x = rand_range(0.25,0.49)
	var y = rand_range(0.25,1.0)
	return Vector2(x,y)

func random_backend_point():
	var x = rand_range(0.50, 0.65)
	var y = rand_range(0.25,0.75)
	return Vector2(x,y)

func random_tail_narrow_point(prevx):
	var x = prevx + rand_range(0.05,0.1)
	var y = rand_range(0.1, 0.2)
	return Vector2(x,y)

func random_tail_wide_point(prevx):
	var x = prevx + rand_range(0.01,0.1)
	var y = rand_range(0.1,0.2)
	return Vector2(x,y)
	
func random_tail_end_point():
	var x = 1.0
	var y = rand_range(0.5,0.75)
	return Vector2(x,y)

func random_back_point():
	var x = 0.0
	var y = rand_range(0.25,1.0)
	return Vector2(x,y)

func random_side_point():
	var x = 0.25
	var y = rand_range(0.25,0.5)
	return Vector2(x,y)

func random_belly_point():
	var x = 0.5
	var y = rand_range(0.25,0.5)
	return Vector2(x,y)
