extends Spatial
class_name SeaBobber

var active = true

export var clampHeight = false
export var minHeight = 0.0
export var maxHeight = 0.0

func _process(delta):
	if active:
		if clampHeight:
			$SeaHeightComponent.height = clamp($SeaHeightComponent.height, minHeight, maxHeight)
		global_transform.origin.y = $SeaHeightComponent.height
