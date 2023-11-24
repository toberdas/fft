extends Spatial

var endlessSeaResource : EndlessSeaResource
var fish_length: float = 50.0

signal follow_submerged


func _process(delta):
	if endlessSeaResource:
		for follow in endlessSeaResource.followList:
			var waterHeight = get_surface_height_at_position(follow.global_transform.origin)
			if follow.has_method("submerged"):
				follow.submerged(waterHeight > follow.global_transform.origin.y)
			if follow.has_method("set_surface_height"):
				follow.set_surface_height(waterHeight)


func get_surface_height_at_position(position):
	var localposition = global_transform.affine_inverse().xform(position)
	var ycheck = 0.0
	var bodyz: float = (localposition.z + fish_length * 0.5) * (1.0 / fish_length)
	var bodyx: float = (localposition.x + fish_length * 0.5) * (1.0 / fish_length)

	bodyz *= PI
	bodyx *= PI
	
	ycheck += cos(endlessSeaResource.time * endlessSeaResource.timeScale + bodyz) * endlessSeaResource.wave 
	ycheck += cos(endlessSeaResource.time * endlessSeaResource.timeScale + bodyx) * endlessSeaResource.wave

	var globalposition = to_global(localposition)
	var worldz: float = (globalposition.z + endlessSeaResource.worldWaveLength * 0.5) * (1.0 / endlessSeaResource.worldWaveLength)
	var worldx: float = (globalposition.x + endlessSeaResource.worldWaveLength * 0.5) * (1.0 / endlessSeaResource.worldWaveLength)
	worldz *= PI
	worldx *= PI
	
	ycheck += cos(endlessSeaResource.time * endlessSeaResource.worldWaveTimeScale + worldz) * endlessSeaResource.worldWaveAmp
	ycheck += cos(endlessSeaResource.time * endlessSeaResource.worldWaveTimeScale + worldx) * endlessSeaResource.worldWaveAmp
	
	return ycheck
