extends Resource
class_name EndlessSeaResource

export(Resource) var seamonsterResource = null

export(Material) var seaChunkMaterialAbove = preload("res://assets/materials/mat_SeaChunk.tres")
export(Material) var seaChunkMaterialUnder = preload("res://assets/materials/mat_SeaChunk_Under.tres")

export(float) var timeScale = 0.8
export(float) var worldWaveLength = 300
export(float) var wave = 6
export(float) var worldWaveAmp = 8
export(float) var worldWaveTimeScale = 0.6

var monsterTarget = null
var followList = []
var time = 0.0

func lerp_to_target_resource(targetResource : EndlessSeaResource, delta):
	worldWaveLength = move_toward(worldWaveLength, targetResource.worldWaveLength, delta * 10)
	wave = move_toward(wave, targetResource.wave, delta * 10)
	worldWaveAmp = move_toward(worldWaveAmp, targetResource.worldWaveAmp, delta * 10)
