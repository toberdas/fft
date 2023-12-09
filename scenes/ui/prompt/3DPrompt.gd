extends Resource
class_name ThreeDPrompt

enum xboxInputs {a,b,x,y,rb,lb}

static func prompt(buttonIndex, location):
	return PromptSingleton.give_prompt(buttonIndex, location)
