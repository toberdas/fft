extends Node

const minDistanceBetweenIslands = .02
const islandLoadDistance = 1500.0
const fishLoadDistnace = 100.0
const worldSize = Vector2(10000.0, 10000.0)
const castLineParts = 16
const maxBaitRadius = 24
const maxBaitTime = 2.0
const maxFishSpeed = 24.0
const defaultComponentScript = preload("res://scenes/interacts/Component.gd")
const maxRocks = 5

const fishCharacteristicsAmount = 2
const wanderPointAmount = 8
const DEBUG = true

const maxScale = 3
const maxHeight = 72

enum baitTastes{sweet,tangy,bitter,salty,sour}
const cellularCutOff = 0.25
