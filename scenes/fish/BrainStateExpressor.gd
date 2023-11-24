extends Spatial

var stateScene = null

func express_state(state):
	clear_state()
	var expressionScene = get_brainstate_expression(state)
	if expressionScene:
		add_expression_scene(expressionScene)
	

func clear_state():
	if stateScene:
		stateScene.queue_free()
	stateScene = null

func get_brainstate_expression(state):
	return state.stateExpressionScene

func add_expression_scene(scene):
	stateScene = scene.instance()
	add_child(stateScene)


func _on_BrainStateNode_brainstate_switched(state):
	express_state(state)
