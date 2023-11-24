extends MeshInstance
class_name FishIslandMeshNode

var fishIslandResource : FishIslandResource setget set_fishisland_resource

func _ready():
	pass

func set_parent_area_target_parent(node):
	$ParentArea.targetParent = node

func set_fishisland_resource(newFishIslandResource):
	fishIslandResource = newFishIslandResource
	mesh = $fishfish.get_node(fishIslandResource.fishMeshName).mesh
	create_trimesh_collision()
	$ParentArea.shapeNode = get_node("FishIslandMeshNode_col").get_child(0)
	set_surface_material(0, fishIslandResource.fishIslandMaterial)
