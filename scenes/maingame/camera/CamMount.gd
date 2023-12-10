extends Follower

export(Environment) var aboveWaterEnvironment

export(ShaderMaterial) var screenMaterial
export(ShaderMaterial) var underwaterMaterial
export(ShaderMaterial) var abovewaterMaterial

onready var camera = $Camera

var underwater = false

func _ready():
	GlobalSingleton.camMount = self
	yield(get_tree().create_timer(1.0), "timeout")
	HelperScripts.switch_parent(self, owner.get_parent())
	$Camera/MeshInstance.set_surface_material(0, screenMaterial)
	
func _enter_tree():
	set_above()

func _process(delta):
	if underwater:
		var smoothDepth = smoothstep(0.0, 200.0, -global_transform.origin.y + 60.0)
		screenMaterial.set_shader_param("fog_intensity", smoothDepth * 0.003)
		screenMaterial.set_shader_param("darkness", smoothDepth)
	pass

func set_above():
	underwater = false
	screenMaterial.set_shader_param("tint", abovewaterMaterial.get_shader_param("tint"))
	screenMaterial.set_shader_param("darkness", abovewaterMaterial.get_shader_param("darkness"))
	screenMaterial.set_shader_param("fog_intensity", abovewaterMaterial.get_shader_param("fog_intensity"))
	screenMaterial.set_shader_param("wave_speed", abovewaterMaterial.get_shader_param("wave_speed"))
	screenMaterial.set_shader_param("wave_freq", abovewaterMaterial.get_shader_param("wave_freq"))
	screenMaterial.set_shader_param("wave_width", abovewaterMaterial.get_shader_param("wave_width"))
	pass

func _on_SeaCheckComponent_emerged():
	set_above()

func _on_SeaCheckComponent_submerged():
	underwater = true
	screenMaterial.set_shader_param("tint", underwaterMaterial.get_shader_param("tint"))
	screenMaterial.set_shader_param("darkness", underwaterMaterial.get_shader_param("darkness"))
	screenMaterial.set_shader_param("fog_intensity", underwaterMaterial.get_shader_param("fog_intensity"))
	screenMaterial.set_shader_param("wave_speed", underwaterMaterial.get_shader_param("wave_speed"))
	screenMaterial.set_shader_param("wave_freq", underwaterMaterial.get_shader_param("wave_freq"))
	screenMaterial.set_shader_param("wave_width", underwaterMaterial.get_shader_param("wave_width"))
	pass


func _on_Player_death():
	screenMaterial.set_shader_param("tint", Color.black)
	screenMaterial.set_shader_param("darkness", 1.0)
	screenMaterial.set_shader_param("fog_intensity", 1.0)
