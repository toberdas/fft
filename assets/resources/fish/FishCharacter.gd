extends Resource
class_name FishCharacter

var brain
var fishSeed = 0

var nervousness = 0.5
var perceptiveness = 0.5
var recoveryCapacity = 0.5
var resilience = 0.5

#default values
var restState = preload("res://assets/resources/fish/states/NeutralState.tres")
var snapState = preload("res://assets/resources/fish/states/AngryState.tres")
var complexState = preload("res://assets/resources/fish/states/AngryState.tres")
var caughtState = preload("res://assets/resources/fish/states/CaughtState.tres")

var stateRuleSet = preload("res://assets/replacementrules/states/StateRuleset.tres")

var characterTagSet = null

var nerve = null
var fishName = null setget ,get_fish_name


func _init(_brain):
	brain = _brain
	
func generate():
	set_traits()
	
	seed(fishSeed)
	characterTagSet = TagSet.new()
	characterTagSet.make_tagset_from_enum(FishEnums.charactertags)

	seed(fishSeed)
	fishName = FishName.new()
	fishName.characterTagSet = characterTagSet
	fishName.make_name()

	set_states()
	
	seed(fishSeed)
	nerve = Nerve.new(recoveryCapacity, resilience)

func set_traits():
	nervousness = randf()
	perceptiveness = randf()
	recoveryCapacity = randf()
	resilience = 1.0 + randf()

func set_states():
	var stateReplacementGrammer = ReplacementGrammar.new()
	stateReplacementGrammer.tagSet = characterTagSet
	var stateString = stateReplacementGrammer.go(stateRuleSet)
	stateString = stateString.strip_edges()
	var stateArray = stateString.split(" ")
	restState = load(stateArray[0])
	snapState = load(stateArray[1])
	complexState = load(stateArray[2])


func get_fish_name():
	if fishName:
		return fishName.nameString
	else:
		return "No name"
