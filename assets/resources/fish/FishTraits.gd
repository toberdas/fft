class_name TraitCollection

var traitArray = []
var amount = 2

func roll_traits():
	for i in range(amount):
		var traitKey = HelperScripts.random_key_from_dict(FishEnums.traits)
		var newTrait = Trait.new(traitKey)
		traitArray.append(newTrait)
