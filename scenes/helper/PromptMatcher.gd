extends Control
class_name PromptMatcher

export var promptArray = []
export var inOrder = true
export var matchMethod = ''
export(AudioStream) var promptMatchSound 
export(AudioStream) var inputMatchSound 
var succesArray = []
var currentInd = 0
var initialized = false

signal inputsuccess
signal inputaudio
signal promptsuccess
signal inputfail

func initialize(_promptArray: Array, _inOrder: bool):
	promptArray = _promptArray
	inOrder = _inOrder
	initialized = true

func _process(_delta):
	if inOrder:
		if Input.is_action_just_pressed(promptArray[currentInd]):
			input_match()
			if currentInd == promptArray.size(): #at the end of the array youve succeeded
				prompt_match()
	else:
		for i in range (promptArray.size()): #iterate through promptarray
#				if input == promptArray[i]: #if input matches given prompt
			if Input.is_action_just_pressed(promptArray[i]):
				if !succesArray.has(i): #if youve havent hit it already
					input_match(i) #succes!
					if succesArray.size() == promptArray.size(): #if youve hit all the inputs
						prompt_match()
					return #stop the loop if succesful!

func input_match(ind = currentInd):
	emit_signal("inputsuccess", ind) #if so well done
	emit_signal("inputaudio")
	currentInd+=1 

func prompt_match():
	emit_signal("promptsuccess")
	queue_free()
