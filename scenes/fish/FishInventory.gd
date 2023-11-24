extends Node

var fishInventory : InventoryResource

func _ready():
	fishInventory = InventoryResource.new()
	fishInventory.itemPickupList = []

func _on_FishAttackNode_food_eaten(itemAttackable):
	fishInventory.pickup_item(itemAttackable.owner)
	itemAttackable.owner.picked_up(self)
