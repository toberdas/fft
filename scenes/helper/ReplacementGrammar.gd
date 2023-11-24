extends Node
class_name ReplacementGrammar

export(Resource) var ruleset
export(bool) var DEBUG = false
var ruleDict = {}
var tagSet = null

func _unhandled_input(event):
	if DEBUG:
		if event.is_action_pressed("action"):
			print_debug(start())

func go(_ruleset):
	ruleset = _ruleset
	pluck_ruleset(ruleset)
	return start()
	
#func _ready(): #testing
#	randomize()
#	pluck_ruleset(ruleset)
#	start()

func pluck_ruleset(set):
	for rule in set.ruleArray:
		add_rule(rule)

func add_rule(rule):
	rule.parse_replacement_string()
	var ruleid = '#' + rule.startSign
	if !ruleDict.has(ruleid):
		ruleDict[ruleid] = rule

func start():
	var startSymbol = "#"+ruleset.startRule.startSign
	return run([startSymbol])

func run(start):
	var string = ""
	if start:
		for symbol in start:
			if symbol.begins_with('#'):
				var newString = run(rule_out(symbol))
				string += newString
			elif symbol.begins_with("@"):
				var newSymbol = symbol.replace("@", "#")
				var newString = run(rule_out(newSymbol)).capitalize()
				string += " " + newString
			else:
				string += symbol
	return string

func rule_out(ruleid):
	if ruleDict.has(ruleid):
		return ruleDict[ruleid].get_rule_out(tagSet)
	else:
		return 'RULE ID ' + ' NOT FOUND IN ' + ruleset.resource_name 
