extends Spatial

export(Resource) var endlessSeaResource = null setget set_endless_sea_resource

var spawned = false
var awakened = false
var target = null

const monsterScene = preload("res://scenes/environment/SeaMonster.tscn")
var monsterInstance = null

func _ready():
	monsterInstance = monsterScene.instance()	

func spawn_monster():
	if awakened && !spawned:
		add_child(monsterInstance)
		monsterInstance.global_transform.origin = target.global_transform.origin
		monsterInstance.global_transform.origin.y = -400
		monsterInstance.target = target
		spawned = true

func start_awakening(_target):
	if !awakened && !spawned:
		awakened = true
		target = _target

func _on_Timer_timeout():
	spawn_monster()

func set_endless_sea_resource(nr):
	if nr:
		endlessSeaResource = nr
		endlessSeaResource.connect("awakened", self, "start_awakening")

