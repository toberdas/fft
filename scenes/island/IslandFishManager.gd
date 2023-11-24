extends Node

#communicates with islandNode if fish are caught, 
#islandNode looks for this node and connects to its propagate_fish_caught signal
#add this islands fish as children to this node

signal propagate_fish_caught

func _ready():
	for fish in get_children():
		fish.connect("caught", self, "on_fish_caught", [], 4) #connect a one-shot signal from fish when it's caught
	pass

func on_fish_caught():
	emit_signal("propagate_fish_caught", get_child_count())
