extends Spatial

export(Resource) var endlessSeaResource = null

var spawned = false

const monsterScene = preload("res://scenes/environment/SeaMonster.tscn")
var monsterInstance = null

func _ready():
	monsterInstance = monsterScene.instance()	

func spawn_monster():
	add_child(monsterInstance)
	monsterInstance.global_transform.origin = endlessSeaResource.monsterTarget.global_transform.origin - Vector3(0.0,200.0,0.0)
	monsterInstance.target = endlessSeaResource.monsterTarget
	spawned = true

func _on_Timer_timeout():
	if endlessSeaResource.monsterTarget && spawned == false:
		spawn_monster()
