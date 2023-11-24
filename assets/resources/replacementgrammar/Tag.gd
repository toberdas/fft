extends Resource
class_name Tag

var tagValue = ''
var readableTag = ''
var weight = 12 setget set_weight

func _init(_tag = null,  _readable = ""):
	if _tag:
		tagValue = _tag
		readableTag = _readable

func set_weight(value):
	weight = value
