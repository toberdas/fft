extends Node
class_name Warning

const warningScene = preload("res://scenes/ui/warnings/WarningNode.tscn")
var myWarningResource
var warningNode

func _init(warningResource:WarningResource):
	myWarningResource = warningResource
	warningNode = warningScene.instance()
	warningNode.init_from_resource(warningResource)
	WarningSingleton.join_bus(self)

func _enter_tree():
	add_child(warningNode)
	warningNode.start()
