extends Node
var eps = 1

var signalDict = {}

func connect_event(eventName : String, connectingNode : Object, connectingTo : Object, functionString : String):
	var _dictArg = []
	var _signal = {
		"callingNode" : connectingNode,
		"connectedNode"  : connectingTo,
		"function"		 : functionString
		}
	if signalDict.has(eventName):
		signalDict[eventName].append(_signal)
	else:
		signalDict[eventName] = [_signal]
	
func emit_event(eventName, args = []):
	if signalDict.has(eventName):
		for connected in signalDict[eventName]:
			emit(connected, args)

func emit(dict, args):
	dict["connectedNode"].callv(dict["function"], args)
