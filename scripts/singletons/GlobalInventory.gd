extends Node

var playerInventory = null
signal equip_updated

var equipDict = {
	"bait" : null,
	"rod" : null,
	"line" : null,
	"memory" : null,
	"net" : null
} setget update_equipDict

func update_equipDict(newdict):
	equipDict = newdict
	emit_signal("equip_updated")
