extends Resource
class_name FishResponse

export(Array, String, "song", "dance", "notetoself", "nothing", "attack", "get scary") var expressionOutcomes = ["nothing"]
export(PackedScene) var expressionScene
export(Resource) var moverResource
export(Array, Resource) var buffs
export(float) var nerveStrain

var body = null
