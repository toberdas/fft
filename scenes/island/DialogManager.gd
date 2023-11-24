extends Node

export(Resource) var defaultDialog
export(NodePath) var label
func _ready():
	label = get_node(label)
#	run_dialog_event(defaultDialog) FOR TESTING

func run_dialog_event(dialog):
	if !dialog && defaultDialog:
		dialog = defaultDialog
	yield(get_tree().create_timer(dialog.secondsBeforeLetterbox), "timeout")	
	$LetterBox.letterbox(true)
	label.set_text("")
	label.modulate = Color(1.0,1.0,1.0,1.0)
	yield($LetterBox, "letterbox_done")
	yield(get_tree().create_timer(dialog.secondsBefore), "timeout")
	$AudioStreamPlayer2D.stream = dialog.responseStream
	$AudioStreamPlayer2D.play()
	label.set_text(dialog.dialogText)
	yield(label, "done_typing")
	yield(get_tree().create_timer(dialog.secondsAfter), "timeout")
	var tween = create_tween()
	tween.tween_property(label, "modulate", Color(1.0,1.0,1.0,0.0), 1.0)
	$LetterBox.letterbox(false)
	pass
