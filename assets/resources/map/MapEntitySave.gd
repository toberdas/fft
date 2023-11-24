extends Resource
class_name MapEntitySave ##All map entities inherit this resource, this is how things are saved in the savedmap

export(Vector2) var point
export(bool) var discovered = true
export(Array) var changes = []

##REQUIERED
export(String) var sceneName
export(float) var loadDistance 

var node = null

func update(map):
	pass


func get_real_point():
	return point * GameplayConstants.worldSize

func add_change(memberName : String, memberValue):
	var newChange = MapEntityChange.new()
	newChange.memberName = memberName
	newChange.memberValue = memberValue
	changes.append(newChange)
