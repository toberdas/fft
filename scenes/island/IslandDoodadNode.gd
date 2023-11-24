extends Spatial

var islandSave : IslandSave
var resource = null
const treeNode = preload("res://scenes/environment/TreeNode.tscn")
const chestScene = preload("res://scenes/interacts/specific/Chest.tscn")
var loadingTrees = false
var treeIndex = 0
var maxTrees = 16

func _on_IslandNode_start_initialize(save):
	loadingTrees = true
	islandSave = save
	resource = islandSave.islandResource	


func _process(delta):
	if resource:
		if loadingTrees:
			var treeArray = resource.islandDoodads.treeArray
			if treeArray.size() > 0:
				var treeResource = treeArray[treeIndex]
				var treeNodeInstance = treeNode.instance()
				$MeshMerger.add_child(treeNodeInstance)
				treeNodeInstance.meshMaterial.albedo_texture = resource.islandDoodads.texture
				treeNodeInstance.make_tree(treeResource)
				treeIndex += 1
				if treeIndex == treeArray.size() or treeIndex > maxTrees:
					loadingTrees = false
			else:
				loadingTrees = false
#				$MeshMerger.merge_meshes_custom(0)
