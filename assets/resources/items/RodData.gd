extends Resource
class_name RodResource

export(PackedScene) var castScene

export(float) var depthPower = 1.0
export(String) var rodMeshName = "BeginnersRod"

export var predictLen = 48
export var predictMaxTry = 128
export var maxCast = 32
export var grav = .1
export var castSpeed = 10

