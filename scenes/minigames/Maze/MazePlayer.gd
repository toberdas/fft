extends TwoDKinematicPlayerMover


export var rope = 160
export var maxDelta = .7

var currentDelta = 0
var pathArray = []


func _process(delta):
	currentDelta += moveInput.length() * delta
	if Input.is_action_pressed("action"):
		memento()
	else:
		if currentDelta > maxDelta:
			currentDelta = 0
			unspool()

func unspool():
	if rope > 0:
		pathArray.append(position)

func memento():
	if pathArray.size()>1:
		if (position - pathArray[-1]).length() > 1:
			position += (pathArray[-1] - position).normalized() * 2
		else:
			position = pathArray.pop_back()
