extends Spatial
class_name FishIsland

signal loaded
var fishIslandSave
var targetBasis = Basis()
var targetHeight = 0.0
var targetHeightAdd = 0.0
var fishIslandResource : FishIslandResource setget set_fishisland_resource

const fishIslandMeshScene = preload("res://scenes/fishisland/bigfishscenes/FishIslandMeshNode.tscn")

func init(save : FishIslandSave):
	fishIslandSave = save 
	set_fishisland_resource(fishIslandSave.fishIslandResource)
	emit_signal("loaded")

func _process(delta):
	if fishIslandSave:
		var realPoint = fishIslandSave.get_real_point()
		global_transform.origin.x = realPoint.x
		global_transform.origin.z = realPoint.y
		var dir = fishIslandSave.targetPoint - fishIslandSave.point
		if !dir.is_equal_approx(Vector2.ZERO):
			global_transform.basis = global_transform.looking_at(global_transform.origin + Vector3(dir.x,0.0,dir.y), Vector3.UP).basis
			targetHeightAdd = -40.0
		else:
			targetHeightAdd = 0.0
	transform.basis = transform.basis.slerp(targetBasis, delta * .2)
	transform.basis = transform.basis.orthonormalized()
	global_transform.origin.y = lerp(global_transform.origin.y, targetHeight + targetHeightAdd, delta * 2.0)

func set_fishisland_resource(newFishIslandResource):
	fishIslandResource = newFishIslandResource
	var levelInstance = fishIslandResource.levelScene.instance()
	var fishInstance = fishIslandMeshScene.instance()
	$SeaBalanceNode/LevelAddNode.add_child(levelInstance)
	$SeaBalanceNode/FishMeshAddNode.add_child(fishInstance)
	levelInstance.fishIslandResource = fishIslandResource
	fishInstance.fishIslandResource = fishIslandResource
	levelInstance.set_parent_area_target_parent(self)
	fishInstance.set_parent_area_target_parent(self)

	
		
func _on_SeaBalanceNode_emit_data(data):
	targetBasis = data["basis"]
	targetHeight = data["height"]
