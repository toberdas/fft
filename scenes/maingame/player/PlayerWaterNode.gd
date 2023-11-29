extends Spatial

export var surfaceMin = 0.0
export var surfaceMax = 3.0

var direction = 0
var emergeTimer : ProcessTimer
var height = 0.0

signal emerged
signal submerged
signal underwater

var isSubmerged = false

func _ready():
	emergeTimer = ProcessTimer.new(16.0)

func _process(delta):
	if isSubmerged:
		var difToSurface = abs(global_transform.origin.y - height)
		if difToSurface > surfaceMax:
			emit_signal("underwater")
		else:
			emit_signal("submerged")
	height = $SeaHeightComponent.surfaceHeight
		

func _on_SeaCheckComponent_emerged():
	isSubmerged = false
	emit_signal("emerged")

func _on_SeaCheckComponent_submerged():
	isSubmerged = true
	emit_signal("submerged")
