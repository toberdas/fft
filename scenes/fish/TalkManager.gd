extends Node
class_name FishTalkManager

var fishTalkScene = preload("res://scenes/fish/FishTalk.tscn")
var fishData = null

signal talk_over
#signal ask_for_motif

#func _on_Fish_start_play():
#	fishTalk = fishTalkScene.instance() #make a new instance of the fishtalk scene, this is where talking and playing minigames will take place in! #THIS NEEDS TO GET SOME FISH-SPECIFIC DATA AT SOME POINT!
#	fishTalk.connect("talkover", self, "talk_over")
##	fishTalk.connect("ask_for_motif", self, "emit_signal", ["ask_for_motif"])
#	fishTalk.init(fishData)
#	add_child(fishTalk) #add the fishtalk scene ofcourse

func make_fishtalk_scene_from_data(fishdata):
	var fishTalk = fishTalkScene.instance() #make a new instance of the fishtalk scene, this is where talking and playing minigames will take place in! #THIS NEEDS TO GET SOME FISH-SPECIFIC DATA AT SOME POINT!
	fishTalk.connect("talkover", self, "talk_over")
#	fishTalk.connect("ask_for_motif", self, "emit_signal", ["ask_for_motif"])
	fishTalk.init(fishdata)
	return fishTalk

func talk_over(win):
	emit_signal("talk_over", win)

func _on_Fish_fishready(fish):
	fishData = fish.fishData
