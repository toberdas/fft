extends Follower

export(Environment) var aboveWaterEnvironment
export(Environment) var underWaterEnvironment

onready var camera = $Camera

func _ready():
	GlobalSingleton.camMount = self
	yield(get_tree().create_timer(1.0), "timeout")
	HelperScripts.switch_parent(self, owner.get_parent())


func _on_SeaCheckComponent_emerged():
	camera.environment = aboveWaterEnvironment


func _on_SeaCheckComponent_submerged():
	camera.environment = underWaterEnvironment
