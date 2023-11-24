extends Resource
class_name Cell

var cellAdditions : CellAdditions

enum state{alive, dying, dead}
var cellState = state.size() - 1

var targetState = cellState
var oldState = cellState

var stateCounter = 0
var targetStateCounter = 0

var location
var birthCounter = 0

var lifeCount = 0

signal cell_death
signal cell_birth

func _init(loc, sc = 0):
	cellAdditions = CellAdditions.new()
	stateCounter = sc
	location = loc

func update_state():
	if cellState == state.alive && targetState == state.dead:
		emit_signal("cell_death", self)
	if cellState == state.dying && targetState == state.dead:
		emit_signal("cell_death", self)
	if cellState == state.dead && targetState == state.alive:
		emit_signal("cell_birth", self)
		birthCounter += 1
	if cellState != targetState:
		cellState = targetState
	stateCounter = targetStateCounter

func revive(states):
	targetState = state.alive
	targetStateCounter = states

func start_dying(states):
	if states > 0:
		targetState = state.dying
	else:
		targetState = state.dead

func death():
	targetState = state.dead
	targetStateCounter = 0
	
func detoriate():
	if cellState == state.dying:
		targetStateCounter = stateCounter - 1
	if targetStateCounter == 0:
		death()

func check_pulse():
	if cellState == state.dying or cellState == state.alive:
		return true
	if cellState == state.dead:
		return false
