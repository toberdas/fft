extends Control


onready var ruleSet = preload("res://assets/replacementrules/sets/LookAtSet.tres")
export(NodePath) var fishTalkLabel
export(NodePath) var memoryButton
var fishData = null

signal switch_screen_out
signal exit_talk

func _ready():
	fishTalkLabel = get_node(fishTalkLabel)
	
	run_dialog_from_ruleset(ruleSet)
	
func _enter_tree():
	if fishData.gameWon:
		if memoryButton is NodePath: memoryButton = get_node(memoryButton)
		memoryButton.disabled = false
	
func run_dialog_from_ruleset(ruleset):
	var replacementGrammar = ReplacementGrammar.new()
	replacementGrammar.tagSet = fishData.brain.character.characterTagSet
	var prompt = replacementGrammar.go(ruleset)
	fishTalkLabel.set_text(prompt) 

func _on_PlayButton_pressed():
	emit_signal("switch_screen_out", "game")

func _on_MemoryButton_pressed():
	emit_signal("switch_screen_out", "memory")

func _on_GoodbyeButton_pressed():
	emit_signal("exit_talk")
