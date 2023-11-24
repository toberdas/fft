extends Node
class_name FishName

var nameString
var characterTagSet
const nameRuleSet = preload("res://assets/replacementrules/name/NameRuleset.tres")

func make_name():
	var nameReplacementGrammar = ReplacementGrammar.new()
	if characterTagSet:
		nameReplacementGrammar.tagSet = characterTagSet
	nameString = nameReplacementGrammar.go(nameRuleSet)
	
