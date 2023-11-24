extends Sprite3D

var dataDict = {}
var targetDict = {}

onready var cp = $Viewport/CatchProgress
onready var lp = $Viewport/LineProgress
onready var tp = $Viewport/TimeProgress


func _ready():
	texture = $Viewport.get_texture()
	if !dataDict.empty():
		cp.progress = 0
		cp.maxValue = dataDict["catchRate"]
		lp.progress = dataDict["lineHealth"]
		lp.maxValue = dataDict["lineHealth"]
		tp.progress = dataDict["time"]
		tp.maxValue = dataDict["time"]

func init(_targetDict):
	targetDict = _targetDict
	dataDict = _targetDict

func _on_Reelin_tick(_dataDict):
	targetDict = _dataDict

func _process(delta):
	$Viewport.size = OS.window_size
	tp.progress = tp.progress - delta
	if !dataDict.empty() && !targetDict.empty():
		for key in dataDict.keys():
			if targetDict.has(key):
				dataDict[key] = lerp(dataDict[key], targetDict[key], delta * 10)
		cp.progress = cp.maxValue - dataDict["catchRate"]
		lp.progress = dataDict["lineHealth"]
