extends ClippedCamera

export(NodePath) var mount

var lastpos 
var targetFOV = 70
var currentFOV = 70

func _ready():
	if mount:
		mount = get_node(mount)
	GlobalSingleton.cam = self #let the globalsingleton know that YOU are the cam
	var panTex = get_parent().find_node('Viewport').get_texture()
	environment.background_sky.set_panorama(panTex)

func _process(delta):
	if currentFOV != targetFOV: #targetfov is set by reelin when reeling in the fish for example
		currentFOV = lerp(currentFOV, targetFOV, 1 * delta)
		set_fov(currentFOV)

