extends Spatial

var steerDirection : float #between -1 and 1
var steerIncrement = .2
var acceleration : float #between -1 and 1
var accelerationIncrement = .2
var isSteering = true

signal steerUpdate

func _ready():
	pass # Replace with function body.

func _process(delta):
	if $SteeringArea.check_if_player_in_area():
		var _steerInput = Vector2.ZERO
		_steerInput.y = int(Input.is_action_pressed("ship_up")) - int(Input.is_action_pressed("ship_down"))

		_steerInput.x = int(Input.is_action_pressed("ship_left")) - int(Input.is_action_pressed("ship_right"))
		if _steerInput.length() > 0.0:
			updateDirection(_steerInput)
				
func updateDirection(input):
	emit_signal("steerUpdate", input.x, input.y)
	pass



func _on_ParentArea_child_parented(child):
	if child is Player:
		isSteering = true


func _on_ParentArea_child_unparented(child):
	if child is Player:
		isSteering = false
		emit_signal("steerUpdate", 0.0, 0.0)
