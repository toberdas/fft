extends Control

signal switch_screen_out
signal game_done
signal exit_talk
signal heart_warmed


var fishData : FishData
var ruleSet : RuleSet

func _ready():
	if fishData:
		$Background.modulate = fishData.color
		$BallSprite.modulate = fishData.color

func _on_2DPickable2_picked(_picker):
	emit_signal("switch_screen_out", "welcome")

func _on_BallSprite_heart_warmed():
	emit_signal("heart_warmed")
