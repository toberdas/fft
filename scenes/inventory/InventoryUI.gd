extends Control

var focusedItemID = ""

export(NodePath) var nameLabel
export(NodePath) var descriptionLabel

func _ready():
	nameLabel = get_node(nameLabel)
	descriptionLabel = get_node(descriptionLabel)

func focus_item(item):
	if item:
		if item.itemID != focusedItemID:
			var r = item.itemResource
			nameLabel.set_text(r.itemName)
			descriptionLabel.set_text(r.description)
		focusedItemID = item.itemID
	else:
		focusedItemID = ""
		nameLabel.set_text("")
		descriptionLabel.set_text("")
