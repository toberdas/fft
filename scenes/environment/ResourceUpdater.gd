extends Node


var endlessSeaResource : EndlessSeaResource

var time = 0.0

func _process(delta):
	if endlessSeaResource:
		endlessSeaResource.time += delta
		endlessSeaResource.seaChunkMaterialAbove.set_shader_param("time", endlessSeaResource.time)
		endlessSeaResource.seaChunkMaterialUnder.set_shader_param("time", endlessSeaResource.time)
		endlessSeaResource.seaChunkMaterialAbove.set_shader_param("wave", endlessSeaResource.wave)
		endlessSeaResource.seaChunkMaterialUnder.set_shader_param("wave", endlessSeaResource.wave)
		endlessSeaResource.seaChunkMaterialAbove.set_shader_param("world_wave_length", endlessSeaResource.worldWaveLength)
		endlessSeaResource.seaChunkMaterialUnder.set_shader_param("world_wave_length", endlessSeaResource.worldWaveLength)
		endlessSeaResource.seaChunkMaterialAbove.set_shader_param("time_scale", endlessSeaResource.timeScale)
		endlessSeaResource.seaChunkMaterialUnder.set_shader_param("time_scale", endlessSeaResource.timeScale)
		endlessSeaResource.seaChunkMaterialAbove.set_shader_param("world_wave_amp", endlessSeaResource.worldWaveAmp)
		endlessSeaResource.seaChunkMaterialUnder.set_shader_param("world_wave_amp", endlessSeaResource.worldWaveAmp)
		endlessSeaResource.seaChunkMaterialAbove.set_shader_param("world_wave_time_scale", endlessSeaResource.worldWaveTimeScale)
		endlessSeaResource.seaChunkMaterialUnder.set_shader_param("world_wave_time_scale", endlessSeaResource.worldWaveTimeScale)
