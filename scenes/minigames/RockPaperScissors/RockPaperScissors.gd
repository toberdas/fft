extends MiniGame

export(float) var delay = .4
export(Array, String) var rockPaperScissorInputs
export(Array, String) var callOutNames
onready var fish = $Fish
onready var you = $You

var count = 0

var switch : Switch

func _ready():
	switch = Switch.new("down")

func get_stick_movement():
	return Input.get_action_strength("movedown") - Input.get_action_strength("moveup")

func _unhandled_input(event):
	for input in rockPaperScissorInputs:
		if Input.is_action_just_pressed(input):
			you.secretHandIndex = rockPaperScissorInputs.find(input)
	var movement = -get_stick_movement()
	if movement > 0:
		var check = switch.check_switch("up")
		if check != null:
			if check:
				fish.move_up()
				yield(get_tree().create_timer(delay * 0.5), "timeout")
				you.move_up()
		
	if movement < 0:
		var check = switch.check_switch("down")
		if check != null:
			if !check:
				fish.secretHandIndex = randi() % 3
				fish.move_down()
				yield(get_tree().create_timer(delay), "timeout")
				you.move_down()
				count += 1
				$Label.text = callOutNames[count - 1]
				if count == 3:
					compare_hands()
					count = 0

func compare_hands():
	var diff = you.secretHandIndex - fish.secretHandIndex
	if diff == 0:
		print('draw')
		delay += 0.02
		return
	if diff == 1 or diff == -rockPaperScissorInputs.size() + 1:
		fish_hit(1)
		print("fish hit")
		return
	else:
		fish_miss(1)
		print("player hit")
