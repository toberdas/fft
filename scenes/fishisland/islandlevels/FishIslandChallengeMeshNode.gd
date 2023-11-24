extends MeshInstance
class_name FishIslandChallengeMeshNode

var fishIslandResource : FishIslandResource setget set_fishisland_resource

export(Array, NodePath) var parentAreaNodesInScenePaths
export(Array, NodePath) var meshInstanceNodesInScenePaths

var parentAreaNodesInScene = []
var meshInstanceNodesInScene = []

func _ready():
	for parentAreaNodePath in parentAreaNodesInScenePaths:
		parentAreaNodesInScene.append(get_node(parentAreaNodePath))
	for meshInstanceNodePath in meshInstanceNodesInScenePaths:
		meshInstanceNodesInScene.append(get_node(meshInstanceNodePath))

func set_parent_area_target_parent(node):
	for parentAreaNode in parentAreaNodesInScene:
		parentAreaNode.targetParent = node

func set_fishisland_resource(newFishIslandResource):
	fishIslandResource = newFishIslandResource
	$Chest.treasureResource = fishIslandResource.treasureResource
	for meshInstanceNode in meshInstanceNodesInScene:
		meshInstanceNode.set_surface_material(0, fishIslandResource.fishIslandMaterial)
