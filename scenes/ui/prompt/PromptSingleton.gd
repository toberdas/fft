extends Node

const promptScene = preload("res://scenes/ui/prompt/3DPromptScene.tscn")

func give_prompt(index, location):
	var promptInstance = promptScene.instance()
#	get_tree().get_root().add_child(promptInstance)
#	promptInstance.global_transform.origin = location
	promptInstance.show_prompt(index)
	return promptInstance
