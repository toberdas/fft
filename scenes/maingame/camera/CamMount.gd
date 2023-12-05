extends Follower

export(Environment) var aboveWaterEnvironment
export(Environment) var underWaterEnvironment

export(Material) var underwaterMaterial
export(Material) var abovewaterMaterial

onready var camera = $Camera

func _ready():
	GlobalSingleton.camMount = self
	yield(get_tree().create_timer(1.0), "timeout")
	HelperScripts.switch_parent(self, owner.get_parent())


func _on_SeaCheckComponent_emerged():
	$Camera/MeshInstance.set_surface_material(0, abovewaterMaterial)
	pass


func _on_SeaCheckComponent_submerged():
	$Camera/MeshInstance.set_surface_material(0, underwaterMaterial)
	pass
