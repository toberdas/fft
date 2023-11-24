extends Control

export(Array, String) var possibleEvents
export(Array, String) var posssibleEventNames
signal success

export var promptArray = []
export var promptLength = 4

#onready var promptMatcher = $PromptMatcher
export(NodePath) var promptMatcher
export(NodePath) var labelParent
var actionArray = []
var labelArray = []

func _ready():
	promptMatcher = get_node(promptMatcher)
	labelParent = get_node(labelParent)
	actionArray = random_inputs(promptLength) #gets an array of random actions, that is the things you make in the inputmap
	promptMatcher.initialize(actionArray[0], true) #initializes the promptmatcher, with the above array, and set the mode to isaction, which means it will check if the input you give is part of one of the actions in above array
	for action in actionArray[1]: #make labels to show the inputprompts
		var l = Label.new()
		l.text = action
		l.size_flags_horizontal = 2
		l.align = 1
		labelArray.append(l)
		labelParent.add_child(l)
		

func random_inputs(_promptLength):
	var randar = []
	var namear = []
	for _i in range(_promptLength):
		var rani = randi() % possibleEvents.size()
		randar.append(possibleEvents[rani])
		namear.append(posssibleEventNames[rani])
	return [randar, namear]


func _on_PromptMatcher_inputsuccess(index): #if the prompmatcher returns succes on an input
	if is_instance_valid(labelArray[index]):
		labelArray[index].text = ":)"


func _on_PromptMatcher_promptsuccess(): #if the promptmatcher has matched the entire promptarray
	emit_signal("success")


func _on_PromptMatcher_inputfail():
	pass # Replace with function body.
