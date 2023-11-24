extends Node

var fishBeingCaught = null

signal fish_netted
signal start_play
signal release_fish
signal caught
signal brokefree

func fish_caught_sequence(fish):
	if fishBeingCaught == null:
		if !fish.is_connected("start_play",self, "emit_play"):
			fish.connect("start_play",self, "emit_play", [], 4)
		if !fish.is_connected("released",self, "emit_release"):
			fish.connect("released",self, "emit_release", [], 4)
		if !fish.is_connected("caught",self, "emit_caught"):
			fish.connect("caught",self, "emit_caught", [], 4)
		if !fish.is_connected("brokefree", self, "emit_brokefree"):
			fish.connect("brokefree", self, "emit_brokefree", [], 4)
		emit_signal("fish_netted", fish)
		fishBeingCaught = fish

func _on_CastManager_fish_caught(fish):
	fish_caught_sequence(fish)

func _on_NetNode_fish_caught(fish):
	fish_caught_sequence(fish)

func emit_play():
	emit_signal("start_play")

func emit_release():
	emit_signal("release_fish")
	reset_fish_being_caught()

func emit_caught(fish):
	emit_signal("caught", fish)
	reset_fish_being_caught()

func emit_brokefree():
	emit_signal("brokefree")
	reset_fish_being_caught()

func reset_fish_being_caught():
	fishBeingCaught = null
