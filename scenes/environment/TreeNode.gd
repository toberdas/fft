extends CellAdditionScene

const meshPath = preload("res://testiing/MeshAlongPathInstance.tscn")
const fruitSpawnerScene = preload("res://scenes/environment/FruitSpawner.tscn")
const attackableNode = preload("res://scenes/helper/AttackableNode.tscn")

export(Material) var meshMaterial

var treeResource : IslandTree
var fruitSpawners = []
var branchSpawnIndex = 0
var spawningBranches = false

func _process(delta):
	if spawningBranches:
		var branch = treeResource.branches[branchSpawnIndex]
		make_branch_mesh(branch)
		branchSpawnIndex += 1
		if branchSpawnIndex == treeResource.branches.size():
			spawningBranches = false

func load_addition():
	treeResource = cellAddition
	transform.origin = treeResource.location
	spawningBranches = true
#	transform.basis = transform.basis.scaled(Vector3.ONE + HelperScripts.random_vec3())
	make_fruit_spawners(treeResource)

func make_branch_mesh(branch : IslandBranch):
	var meshPathInstance = meshPath.instance()
	for point in branch.pointArray:
		meshPathInstance.curve.add_point(point)
	add_child(meshPathInstance)
	meshPathInstance.lengthCurve = branch.curve
	meshPathInstance.sides = 4
	meshPathInstance.stemThickness = treeResource.data.thickness
	meshMaterial.distance_fade_min_distance = GameplayConstants.islandLoadDistance - 300
	meshMaterial.distance_fade_max_distance = GameplayConstants.islandLoadDistance - 600
	meshPathInstance.meshMaterial = meshMaterial
	meshPathInstance.run()
	meshPathInstance.add_collision()
	
	var attackableInstance = attackableNode.instance()
	attackableInstance.set_shape(meshPathInstance.get_shape())
	meshPathInstance.add_child(attackableInstance)
	attackableInstance.add_to_group("Trees")
	attackableInstance.scale *= 1.2
	attackableInstance.connect("attacked", self, "tree_attacked")
		
func make_fruit_spawners(treeResource: IslandTree):
	for spawnerResource in treeResource.fruitSpawns:
		var spawnerInstance = fruitSpawnerScene.instance()
		add_child(spawnerInstance)
		spawnerInstance.transform.origin = spawnerResource.location
		spawnerInstance.look_at(spawnerResource.location + spawnerResource.upVector * 5.0,Vector3.UP)
		spawnerInstance.scale *= spawnerResource.scale
		spawnerInstance.start_growing()
		fruitSpawners.append(spawnerInstance)
	pass

func tree_attacked(attacker):
	if attacker.is_in_group("Player"):
		for i in range(4 + randi() % 4):
			$AnimationPlayer.play("shake")
			var randomFruitSpawner = HelperScripts.random_value_from_array(fruitSpawners)
			if randomFruitSpawner:
				randomFruitSpawner.drop_fruit()
