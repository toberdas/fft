extends Resource
class_name Dialog

export(String, MULTILINE) var dialogText = ""
export(int, "on_island_approach", "on_fish_caught", "on_last_fish") var trigger
export(float) var secondsBeforeLetterbox = 2.0
export(float) var secondsBefore = 1.0
export(float) var secondsAfter = 3.0
export(AudioStream) var responseStream
export var played = false setget set_played,get_played

func set_played(val):
	played = val

func get_played():
	return played
