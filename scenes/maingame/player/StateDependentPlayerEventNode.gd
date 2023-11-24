extends Spatial
class_name StateDependentPlayerEventNode

export(NodePath) var pathToPlayer
export(Array, Player.state) var allowedStates 

var player = null
var active = false

func _ready():
	player = get_node(pathToPlayer)

func _process(_delta):
	if check_conditions():
		if allowedStates.has(player.currentState):
			active = true
			start_event()
			return
	if check_deactivate_conditions():
		active = false
		stop_event()
	
func start_event():
	pass

func stop_event():
	pass

func check_conditions():
	return false

func check_deactivate_conditions():
	return false
