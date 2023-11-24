extends MeshAlongPath
tool

var time = 0
var speed = 0

func _process(delta):
	time += delta * speed
	meshMaterial.set_shader_param("time", time)

func run_from_data(fishMeshCurveData:FishMeshCurveData):
	curve.clear_points()
	curve.add_point(Vector3(0.0,0.0,-1.0))
	curve.add_point(fishMeshCurveData.shoulderPoint,fishMeshCurveData.shoulderIn,fishMeshCurveData.shoulderOut)
	curve.add_point(fishMeshCurveData.hipPoint,fishMeshCurveData.hipIn,fishMeshCurveData.hipOut)
	curve.add_point(Vector3(0.0,0.0,1.0))
	set_length_curve_from_data(fishMeshCurveData)
	set_width_curve_from_data(fishMeshCurveData)
	
	run()

func set_length_curve_from_data(fishMeshCurveData:FishMeshCurveData):
	lengthCurve = Curve.new()
	lengthCurve.add_point(fishMeshCurveData.nosePoint)
	lengthCurve.add_point(fishMeshCurveData.foreheadPoint)
	lengthCurve.add_point(fishMeshCurveData.backStartPoint)
	lengthCurve.add_point(fishMeshCurveData.backEndPoint)
	lengthCurve.add_point(fishMeshCurveData.tailNarrowPoint)
	lengthCurve.add_point(fishMeshCurveData.tailWidePoint)
	lengthCurve.add_point(fishMeshCurveData.tailEndPoint)

func set_width_curve_from_data(fishMeshCurveData:FishMeshCurveData):
	widthCurve = Curve.new()
	widthCurve.add_point(fishMeshCurveData.backPoint)
	widthCurve.add_point(fishMeshCurveData.sidePoint)
	widthCurve.add_point(fishMeshCurveData.bellyPoint)
	widthCurve.add_point(fishMeshCurveData.sidePoint2)
	widthCurve.add_point(fishMeshCurveData.backPoint2)

func _on_Fish_fishready(fish):
	var fishData : FishData = fish.fishData
	meshMaterial.set_shader_param("texture_albedo", fishData.texture)
	run_from_data(fishData.meshCurves)
	meshMaterial.set_shader_param("albedo", fishData.color)



func _on_FishSpeedNode_speed_out(_speed):
	speed = _speed
