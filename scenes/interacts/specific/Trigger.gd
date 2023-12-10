extends CellAdditionScene

var triggerResource setget set_trigger_resource

onready var button_animation_player = $ButtonAnimationPlayer

onready var button_mesh_instance = $Trigger/triggerbutton

signal triggered

func load_addition():
	triggerResource = cellAddition

func _process(delta):
	if triggerResource:
		triggerResource.process(delta)
		if triggerResource.is_condition_met():
			button_mesh_instance.get_active_material(0).albedo_color = Color.green
		else:
			button_mesh_instance.get_active_material(0).albedo_color = Color.red

func set_trigger_resource(newTriggerResource):
	triggerResource = newTriggerResource
	triggerResource.connect("condition_is_met", self, "on_condition_met")
	triggerResource.connect("condition_is_reset", self, "on_condition_reset")
	triggerResource.connect("untriggered", self, "on_untrigger")

func on_condition_met():
	pass

func on_condition_reset():
	pass
	
func on_untrigger():
	button_animation_player.play_backwards("ButtonGoesDown")

func _on_ButtonPickable_picked(_pointer):
	if triggerResource.is_condition_met():
		triggerResource.triggered = true
		button_animation_player.play("ButtonGoesDown")
	else:
		pass
