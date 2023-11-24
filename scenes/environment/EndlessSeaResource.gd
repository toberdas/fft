extends Resource
class_name EndlessSeaResource

export(Material) var seaChunkMaterialAbove = preload("res://assets/materials/mat_SeaChunk.tres")
export(Material) var seaChunkMaterialUnder = preload("res://assets/materials/mat_SeaChunk_Under.tres")

export(float) var timeScale = 0.8
export(float) var worldWaveLength = 300
export(float) var wave = 6
export(float) var worldWaveAmp = 8
export(float) var worldWaveTimeScale = 0.6

#var wildness = 0.5
var followList = []
var time = 0.0

func lerp_to_target_resource(targetResource : EndlessSeaResource, delta):
#	timeScale = move_toward(timeScale, targetResource.timeScale, delta)
	worldWaveLength = move_toward(worldWaveLength, targetResource.worldWaveLength, delta)
	wave = move_toward(wave, targetResource.wave, delta)
	worldWaveAmp = move_toward(worldWaveAmp, targetResource.worldWaveAmp, delta)
#	worldWaveTimeScale = move_toward(worldWaveTimeScale, targetResource.worldWaveTimeScale, delta)
