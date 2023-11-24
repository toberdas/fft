extends Resource
class_name FruitSpawnerResource

var location : Vector3
var upVector : Vector3
var fruitItem

var scale = 1.0

func generate():
	scale += randf() * 2.0
