extends Control


func make_from_choice_resource(choiceResource : ChoiceResource):
	$PromptEye/Label.text = choiceResource.promptLabel
	var acceptFormatString = "%s - %s"
	$AcceptEye/Label.text = acceptFormatString % [choiceResource.acceptInputName,choiceResource.acceptLabel]
	var denyFormatString = "%s - %s"
	$DenyEye/Label.text = denyFormatString % [choiceResource.denyInputName, choiceResource.denyLabel]
	$AnimationPlayer.playback_speed = choiceResource.openAnimationSpeed
	$AnimationPlayer.play("open")


