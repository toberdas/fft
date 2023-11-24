extends Spatial

signal situation_sense

var sensedBodies = TimerDictionary.new()
const sensedTime = 4.0
var processTimer = ProcessTimer.new(2.0)

func _process(delta):
	if processTimer.tick():
		processTimer.reset()

func _on_FishSense_identifiedsensed(body):
	if !processTimer.is_timed_out():
		if !check_if_in_sensed_bodies(body):
			choose_signal(body)
			add_to_sensed_bodies(body)
		else:
			pass

func _on_FishSense_dangersensed(body):
	if !check_if_in_sensed_bodies(body):
		choose_signal(body)
		add_to_sensed_bodies(body)
	else:
		pass

	
func choose_signal(body):
	if body.is_in_group("ScaryToFish"):
		emit_signal("situation_sense", body, 'threat')
		return
	if body.is_in_group("Fish"):
		emit_signal("situation_sense", body, 'fish')
		return
	if body.is_in_group("Food"):
		if $HungerNode.wants_to_eat(body):
			emit_signal("situation_sense", body, 'food')
		return

func add_to_sensed_bodies(body):
	sensedBodies.add_item_with_key_time(body, body.get_instance_id(), sensedTime)

func check_if_in_sensed_bodies(body):
	return sensedBodies.has(body.get_instance_id())
	
func tick_sensed_bodies_time(delta):
	sensedBodies.tick_time(delta)

func _on_SensedTimer_timeout():
	tick_sensed_bodies_time(1)
