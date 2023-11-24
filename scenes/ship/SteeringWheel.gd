extends Spatial

var steerDirection : float #between -1 and 1
var steerIncrement = .2
var acceleration : float #between -1 and 1
var accelerationIncrement = .2
var isSteering = true

signal steerUpdate

func _ready():
	pass # Replace with function body.

#func _process(_delta):
#	var upgDict = get_parent().get_node("Upgrader").get_relevant_upgrades(name)
#	if $SteeringArea.check_if_player_in_area():
#		if isSteering:
#			var _steerInput = Vector2.ZERO
#			if Input.is_action_just_pressed("ship_down"):
#				_steerInput.y -= 1.0
#			if Input.is_action_just_pressed("ship_up"):
#				_steerInput.y += 1.0
#			if Input.is_action_just_pressed("ship_left"):
#				_steerInput.x += 1.0
#			if Input.is_action_just_pressed("ship_right"):
#				_steerInput.x -= 1.0
#			if _steerInput.length() > 0.0:
#				updateDirection(_steerInput)

#func _unhandled_input(event):
#	if $SteeringArea.check_if_player_in_area():
#		if isSteering:
#			var _steerInput = Vector2.ZERO
#			if Input.is_action_pressed("ship_down"):
#				_steerInput.y -= 1.0
#			if Input.is_action_pressed("ship_up"):
#				_steerInput.y += 1.0
#			if Input.is_action_pressed("ship_left"):
#				_steerInput.x += 1.0
#			if Input.is_action_pressed("ship_right"):
#				_steerInput.x -= 1.0
#			if _steerInput.length() > 0.0:
#				updateDirection(_steerInput)

func _process(delta):
#	if $SteeringArea.check_if_player_in_area():
#		if isSteering:
	var _steerInput = Vector2.ZERO
	_steerInput.y = int(Input.is_action_pressed("ship_up")) - int(Input.is_action_pressed("ship_down"))

	_steerInput.x = int(Input.is_action_pressed("ship_left")) - int(Input.is_action_pressed("ship_right"))
	if _steerInput.length() > 0.0:
		updateDirection(_steerInput)
				
func updateDirection(input):
#
#	steerDirection += input.x * steerIncrement
#	steerDirection = clamp(steerDirection, -1.0, 1.0)
#	acceleration += input.y * accelerationIncrement
#	acceleration = clamp(acceleration, -1.0, 1.0)
#	print([steerDirection, acceleration])
	emit_signal("steerUpdate", input.x, input.y)
	pass



func _on_ParentArea_child_parented(child):
	if child is Player:
		isSteering = true


func _on_ParentArea_child_unparented(child):
	if child is Player:
		isSteering = false
		emit_signal("steerUpdate", 0.0, 0.0)
