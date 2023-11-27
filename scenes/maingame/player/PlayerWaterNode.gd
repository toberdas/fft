extends Spatial

var direction = 0
var emergeTimer : ProcessTimer
var height = 0.0

signal emerged
signal submerged

func _ready():
	emergeTimer = ProcessTimer.new(16.0)

func _process(delta):
	if direction != 0:
		if emergeTimer.tick():
			if direction == 1:
				print("above water")
				$SeaHeightComponent.active = false
				emit_signal("emerged")
			if direction == -1:
				print("underwater")
				$SeaHeightComponent.active = true
				emit_signal("submerged")
			emergeTimer.reset()
			direction = 0
	height = $SeaHeightComponent.height
		

func _on_SeaCheckComponent_emerged():
	emergeTimer.reset()
	direction = 1

func _on_SeaCheckComponent_submerged():
	emergeTimer.reset()
	direction = -1
