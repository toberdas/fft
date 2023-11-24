extends Resource
class_name FlockData

export var sepFactor = 0.5
export var coheFactor = 0.5
export var alignFactor = 0.5
export var sepRange = 12
export var coheRange = 12
export var alignRange = 12
export var slowdownRange = 1

var fishAmount = 12
var fishData = []
var pointList = []
var islandCellular = null
var fishType = null
