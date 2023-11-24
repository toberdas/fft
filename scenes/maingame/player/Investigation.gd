extends Node

onready var titelLabel = $Control/Sprite2/TypingLabel
onready var descriptionLabel = $Control/Sprite/TypingLabel


func _on_2DPointer_picked(pickable):
	var interestingBody = pickable.owner
	if interestingBody is Fish:
		titelLabel.text = interestingBody.fishData.brain.character.fishName
		var descriptionText = "Likes : %s \n "
		descriptionLabel.text = descriptionText % [str(interestingBody.fishData.baitPreference)]
	if interestingBody is FishIsland:
		titelLabel.text = interestingBody.fishIslandResource.fishName
		descriptionLabel.text = interestingBody.fishIslandResource.description
		if interestingBody.fishIslandSave:
			interestingBody.fishIslandSave.discovered = true
	if interestingBody is ThreeDItem:
		titelLabel.text = interestingBody.itemResource.itemName
		descriptionLabel.text = interestingBody.itemResource.description
