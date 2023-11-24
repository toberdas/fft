extends Spatial

var baitData = {}

func _ready():
	baitData["type"] = ["sweet"]
	baitData["smellStrength"] = 0.1
	var _ce = $BaitEmitter.connect("body_entered", self, "fish_baited")

func fish_baited(body):
	if body.is_in_group("Fish"): #check to see if you hit a fish
		if body.has_method("bait"): #check to see if the fish has a method when hit by bait
			body.bait(self, baitData) #run the fish' bait method, supplying a reference to itself and the type of bait used
