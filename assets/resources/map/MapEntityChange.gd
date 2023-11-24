extends Resource
class_name MapEntityChange

export(Array, String) var memberPath
export(String) var methodName
export(Array) var argArray

func commit_change(mapSave):
	var object = null
	for memberPathStep in memberPath:
		object = mapSave.get(memberPathStep)
	object.callv(argArray)
