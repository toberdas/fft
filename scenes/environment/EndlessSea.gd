extends Spatial
class_name EndlessSea

const seaChunk = preload("res://scenes/environment/SeaChunk.tscn")

export var endlessSeaResource : Resource setget set_endless_sea_resource

var currentChunks = {}
var chunkSize = 100
var chunkDepth = 14
var currentPlayerVec = Vector2.ZERO



func set_params():
	pass

func scale_and_check_position(position:Vector3, alwaysload = false):
	var chunkVec = Vector2(floor(position.x/chunkSize), floor(position.z/chunkSize))
	if chunkVec != currentPlayerVec or alwaysload:
		currentPlayerVec = chunkVec
		chunker(chunkVec)

func chunker(chunkVec):
	for key in currentChunks.keys():
		currentChunks[key]["cleanup"] = true
	for i in range(-chunkDepth, chunkDepth):
		for j in range(-chunkDepth, chunkDepth):
			var newVec = chunkVec + Vector2(i,j)
			if !currentChunks.has(newVec):
				generate_chunk(newVec)
			else:
				currentChunks[newVec]["cleanup"] = false
	for key in currentChunks.keys():
		if currentChunks[key]["cleanup"] == true:
			cleanup_chunk(key)

func generate_chunk(vec):
	var ins = seaChunk.instance()
	ins.endlessSeaResource = endlessSeaResource
	add_child(ins)
	var nv = vec * chunkSize
	ins.global_transform.origin = Vector3(nv.x, 0.0, nv.y)
	currentChunks[vec] = {"instance" : ins, "cleanup" : false}
	pass
	
func cleanup_chunk(key):
	currentChunks[key]["instance"].queue_free()
	currentChunks.erase(key)

func set_endless_sea_resource(newResource):
	endlessSeaResource = newResource
	$UnderWaterChecker.endlessSeaResource = newResource
	$ResourceUpdater.endlessSeaResource = newResource
	$SeaMonsterAwakening.endlessSeaResource = newResource
