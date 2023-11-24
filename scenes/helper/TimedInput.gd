extends Node
class_name TimedInput

var choiceResource : ChoiceResource
var time = 1
var input = "x"
var cancelInput = "y"

signal fail
signal success

const choiceUIScene = preload("res://scenes/ui/ChoiceUI.tscn")

func _init(_choiceResource : ChoiceResource, _callingNode, succesfunc, failfunc):
	choiceResource = _choiceResource
	var _err = connect("success", _callingNode, succesfunc)
	_err = connect("fail", _callingNode, failfunc)
	input = choiceResource.acceptInputName
	cancelInput = choiceResource.denyInputName
	time = choiceResource.time
	_callingNode.add_child(self)

func _ready():
	if choiceResource:
		if choiceResource.hasUI:
			var choiceUIInstance = choiceUIScene.instance()
			add_child(choiceUIInstance)
			choiceUIInstance.make_from_choice_resource(choiceResource)
	
func _process(delta):
	time -= delta
	if time <= 0:
		fail()
	if Input.is_action_pressed(input):
		success()
	if Input.is_action_pressed(cancelInput):
		fail()

func fail():
	emit_signal("fail")
	queue_free()

func success():
	emit_signal("success")
	queue_free()
