extends Spatial

var lineArray = [] #the linearray thats given to the drawing line
var lineTargetArray = [] #the array of points the above array moves towards?
var scaledArray = []
var curve = preload("res://assets/curves/1d_curve_1.tres")
var casting = false
#var threedcurve = preload("res://assets/curves/castcurves/castcurve_1.tres")
var threedcurve = null
var lineLength = 0
var fallSpeed = 0.05
var castFailed = false

export(Curve) var speedCurve
var castResource : CastResource

onready var castbobber = $CastPath/DetectingPathwalker/Bobber #get the bobber, parents will change alot.
onready var detecting_pathwalker = $CastPath/DetectingPathwalker

signal castdone
signal castcancelled
signal reeledin
	
func _process(delta):
	if casting:
		line_to_rest(fallSpeed)
		if detecting_pathwalker.walk_path(delta) > 0.95:
			Warning.new(preload("res://scenes/ui/warnings/NothingHitWithBobberWarning.tres"))
			casting = false
			castFailed = true
			fallSpeed += 0.5
		$Chain.unfreeze_partial(detecting_pathwalker.unit_offset)
		$CastLine.points = HelperScripts.fraction_array(lineArray, detecting_pathwalker.unit_offset) #update points of drawline
		if detecting_pathwalker.bodyHit:
			print('body hit')
			casting = false
			$Chain.cut_chain(detecting_pathwalker.unit_offset)
			$CastPath.curve = $Chain.curve_from_chain()
			lineArray = Array($CastPath.curve.get_baked_points())
			$CastLine.points = lineArray
			$Chain.fasten_to_anchor(castbobber)
			$Chain.anchor_to_node(detecting_pathwalker.bodyHit)
			fallSpeed += 1.0
	else:
		line_to_rest(fallSpeed)
	if castFailed:
		var c = reel_in(.1)
		if c:
			castResource.stop_cast()
			queue_free()
			

func start_cast(predictDict):
	castbobber.castResource = castResource
	castbobber.add_bait()
	var linear = get_line_distributed_points(predictDict["linearray"])
	var dist = (linear.front() - linear.back()).length()
	var resolution = int(max(8, dist / 3.0))
	resolution = int(min(resolution, 32))
	scaledArray = HelperScripts.scale_array(linear, resolution) #Scale the predictarray to a certain castresolution 
	var curvyPath = $CastPath.create_curvy_path(scaledArray, threedcurve) #castpath makes a curvy path from the scaledarray, and tries to get in and out points from the curve supplied, if no curve is supplied, ZERO in and out points will be added
	$Chain.make_chain_on_array(scaledArray) #make chain of rigidbodies for castline to follow later
	yield($Chain, "chain_done")
#
	casting = true
	$CastPath.curve = curvyPath
	detecting_pathwalker.recalculate_target()
#	lineArray = Array($CastPath.curve.tessellate())
	lineArray = Array($CastPath.curve.get_baked_points())
	$Chain.path_to_links($CastPath) #sets points in castpath to position of links (for as many links as there are)
	$CastLine.set_visible(true) #flick on castline

func line_to_rest(fallspeed): #no real use for fallspeed as rigidbodies already move fluidly
	var size = lineArray.size()
	$Chain.path_to_links($CastPath) #sets points in castpath to position of links (for as many links as there are)
	lineTargetArray = HelperScripts.curve_to_array($CastPath, size) #get array of points of size of linearray from the newly updated castpath
	if size > 0:
		for i in size:
			lineArray[i] = lineArray[i].move_toward(lineTargetArray[i], fallspeed) #set lineArray's points to newly gotten lineTargetArrays points, creating a bobbing line+
	$CastLine.points = lineArray #update points of drawline

func reel_in(amount):
	lineLength = max(lineLength, lineArray.size())
	for _i in range(min(amount * lineLength, lineArray.size())):
		lineArray.pop_back()
		lineTargetArray.pop_back()
	if lineArray.size() > 0:
		detecting_pathwalker.global_transform.origin = lineArray.back()
		line_to_rest(0.06)
		return false
	else:
		emit_signal("reeledin")
		return true

func get_line_distributed_points(lineArray:Array):
	var curve = Curve3D.new()
	for point in lineArray:
		curve.add_point(point)
	return Array(curve.get_baked_points())
