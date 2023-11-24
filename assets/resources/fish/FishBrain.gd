extends Resource
class_name FishBrain

var fishSeed = 0
var currentState = null
var stateType = 0
var memory = null
var character : FishCharacter = null
var brainRefresh = 0.0

func generate():
	character = FishCharacter.new(self)
	character.fishSeed = fishSeed
	character.generate()
	currentState = character.restState
	seed(fishSeed)
	memory = FishMemory.new(self)
	brainRefresh = 6.0 + randf() * 6.0

func switch_state(newstate):
	currentState = newstate

func go_to_caught_state():
	switch_state(character.caughtState)
	
func go_to_rest_state():
	switch_state(character.restState)
