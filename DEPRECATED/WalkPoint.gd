extends Node
class_name WalkPoint

var matrixPoint = Vector3.ZERO
var latestIndex = 0
var connections = []
var islandSpacePosition = Vector3.ZERO

func _init(_matrixPoint = Vector3.ZERO, _latestIndex = 0, _connections = [Vector3(0.02,0.0,0.0)], _islandSpacePosition = Vector3.ZERO):
	matrixPoint = _matrixPoint
	latestIndex = _latestIndex
	connections = _connections
	islandSpacePosition = _islandSpacePosition
