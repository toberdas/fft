extends Spatial

var baitData = {}
var castResource : CastResource

var follow = null
var nibble = false

const itemScene = preload("res://scenes/item/3DItem.tscn")

func _process(_delta):
	if follow:
		global_transform.origin = follow.global_transform.origin

func add_bait():
	var baitPickup = castResource.get_equiped_bait()
	if baitPickup:
		var baitInstance = itemScene.instance()
		baitInstance.canBePickedUp = false
		add_child(baitInstance)
		baitInstance.freeze()
		baitInstance.connect("item_gone", self, "bait_eaten")
		baitInstance.itemResource = baitPickup.itemResource

func bait_eaten():
	castResource.bait_is_eaten()

func change_parent(newparent):
	get_parent().remove_child(self)
	newparent.add_child(self)

func fish_hooked():
	castResource.hooked_fish()
	
func ignore_nibble():
	castResource.ignore_nibbling()
	nibble = false

func nibble(fish):
	if nibble == false:
		nibble = true
		castResource.nibbled_fish(fish)
		var _nibbleNode = TimedInput.new(preload("res://assets/resources/choices/FishNibbleChoice.tres"), self, "fish_hooked", "ignore_nibble")

func _on_AttackableNode_attacked(bitingFish):
	nibble(bitingFish.owner)
	
