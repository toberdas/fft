extends Control


var dataDict = {}
var targetDict = {}

export(NodePath) var catchProgress
export(NodePath) var lineHealthProgress
export(NodePath) var timeProgress



func _ready():
	catchProgress = get_node(catchProgress)
	lineHealthProgress = get_node(lineHealthProgress)
	timeProgress = get_node(timeProgress)
	if !dataDict.empty():
		catchProgress.progress = 0
		catchProgress.maxValue = dataDict["catchRate"]
		lineHealthProgress.progress = dataDict["lineHealth"]
		lineHealthProgress.maxValue = dataDict["lineHealth"]
		timeProgress.progress = dataDict["time"]
		timeProgress.maxValue = dataDict["time"]

func init(_targetDict):
	targetDict = _targetDict
	dataDict = _targetDict

func _on_Reelin_tick(_dataDict):
	targetDict = _dataDict

func _process(delta):
	timeProgress.progress = timeProgress.progress - delta
	if !dataDict.empty() && !targetDict.empty():
		for key in dataDict.keys():
			if targetDict.has(key):
				dataDict[key] = move_toward(dataDict[key], targetDict[key], delta * 10)
		catchProgress.progress = catchProgress.maxValue - dataDict["catchRate"]
		lineHealthProgress.progress = dataDict["lineHealth"]
