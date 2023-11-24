extends Label

var currentInd = 0
var typing = false
var stringLength = 0

export var typeSpeed = 12
export var extraSpeed = 12
export(bool) var typeSound = true

var realTypeSpeed

signal done_typing
signal letter_typed

func _ready():
	if !typeSound:
		$AudioStreamPlayer.queue_free()

func _process(delta):
	if Input.is_action_pressed("a"):
		realTypeSpeed = typeSpeed + extraSpeed
	else:
		realTypeSpeed = typeSpeed
	if typing: 
		typing = type_text(delta)

func set_text(string: String): #override set_text method
	text = string #actually set text to given string
	typing = true #set typing to true so the node can start typing the new text
	currentInd = 0 #set currentInd to 0 so we will type from the first letter
	stringLength = string.length()
	set_visible_characters(0) #so that you dont get a flash of the full string

func type_text(delta): #typing the text
	if int(currentInd) < stringLength: #as long as you havent reached the end of the text
		currentInd += delta * realTypeSpeed #increment currentind by delta times typespeed ensuring it runs the same on different computers
		var lastVisChars = visible_characters
		var percent = currentInd/stringLength
		percent_visible = percent
		if visible_characters > lastVisChars:
			letter_up()
		return true #if you havent reached the end return true
	else:
		typing = false
		emit_signal("done_typing") #emit signal that you are done typing
		return false #otherwise return false, setting typing to false, ending the type-text sequence

func letter_up():
	emit_signal("letter_typed")
