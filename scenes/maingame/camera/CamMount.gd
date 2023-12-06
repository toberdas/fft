extends Follower

export(Environment) var aboveWaterEnvironment

export(ShaderMaterial) var underwaterMaterial
export(ShaderMaterial) var abovewaterMaterial

onready var camera = $Camera

var underwater = false

func _ready():
	GlobalSingleton.camMount = self
	yield(get_tree().create_timer(1.0), "timeout")
	HelperScripts.switch_parent(self, owner.get_parent())

func _process(delta):
	var smoothDepth = smoothstep(0.0, 200.0, -global_transform.origin.y + 60.0)
	underwaterMaterial.set_shader_param("fog_intensity", smoothDepth * 0.003)
	underwaterMaterial.set_shader_param("darkness", smoothDepth)
	pass
	
func _on_SeaCheckComponent_emerged():
	underwater = false
	$Camera/MeshInstance.set_surface_material(0, abovewaterMaterial)
	pass


func _on_SeaCheckComponent_submerged():
	underwater = true
	$Camera/MeshInstance.set_surface_material(0, underwaterMaterial)
	pass
