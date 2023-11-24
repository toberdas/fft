extends Node2D

export(String, MULTILINE) var tooltipString
export(String, MULTILINE) var nameString

export(NodePath) var toolTipTarget
export(NodePath) var nameTarget

func _ready():
	if toolTipTarget:
		if toolTipTarget is NodePath:
			toolTipTarget = get_node(toolTipTarget)
	else:
		toolTipTarget = $ToolTipLabel
		
	if nameTarget:
		if nameTarget is NodePath:
			nameTarget = get_node(nameTarget)
	else:
		nameTarget = $NameLabel

func focus():
	toolTipTarget.text = tooltipString
	nameTarget.text = nameString

func unfocus():
	toolTipTarget.text = ""
	nameTarget.text = ""
