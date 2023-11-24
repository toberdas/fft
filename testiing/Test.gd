extends Spatial
class_name Test

signal test1
signal test2
signal test3

func _process(delta):
	if Input.is_action_just_pressed("jump"):
		test1()
	if Input.is_action_just_pressed("ui_up"):
		test2()
	if Input.is_action_just_pressed("ui_down"):
		test3()
		
	
func test1():
	emit_signal("test1")
	pass

func test2():
	emit_signal("test2")
	pass

func test3():
	emit_signal("test3")
	pass
