extends Node

var currentWarning = null
var warningBus = []

func join_bus(warning):
	if !find_same_warning_in_bus(warning):
		warningBus.append(warning)
		if currentWarning == null:
			add_oldest_warning()

func find_same_warning_in_bus(warning):
	for _warning in warningBus:
		if _warning.myWarningResource == warning.myWarningResource:
			return true
	return false

func add_oldest_warning():
	var warning = warningBus.pop_front()
	get_tree().get_root().add_child(warning)
	warning.connect("tree_exiting", self, "check_bus")
	currentWarning = warning

func check_bus():
	currentWarning = null
	if warningBus.size() > 0:
		add_oldest_warning()
