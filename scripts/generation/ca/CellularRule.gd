extends Resource
class_name CellularRule

var states = 0
var stochastic = false
var neighbourhood = null
var aliveAmounts = []
var reviveAmounts = []

func _init(preset, stoch):
	stochastic = stoch
	var presetArray = CellularAutomataData.presetArray
	aliveAmounts = presetArray[preset]['stayAlive']
	reviveAmounts = presetArray[preset]['rebirth']
	neighbourhood = Neighbourhood.new(presetArray[preset]['neighbour'])
	states = presetArray[preset]['states']

func check_count(count, ar):
	if count < 0: return false
	if ar.has(count):
		if stochastic:
			if randf() > GameplayConstants.cellularCutOff:
				return true
			else:
				return false
		return true
	return false

func check_alive(count):
	return check_count(count, aliveAmounts)

func check_revive(count):
	return check_count(count, reviveAmounts)
