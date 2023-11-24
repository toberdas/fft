extends Spatial

var castResource : CastResource

var predictDict = {}
var predictTime = 0.06
var depthPower = 2
var predictMaxTry = 64

onready var trajectory = $Trajectory

var curve = Curve3D.new() #curve is used to make a evenly distributed array of points, from a probe that moves faster and faster depending on increment used

func _process(delta):
	predictDict = trajectory.update_trajectory(predictTime, depthPower, predictMaxTry) #every step update the predictline, returns an array consisting of the body the predictbobber has hit, and the line the bobber has made. returns null on body if nothing was hit
	predictTime = move_toward(predictTime, 1.0, delta * 0.4)

