extends Menu


const fishListScene = preload("res://scenes/ship/ShipFishList.tscn")
var fishListInstance = null

signal emit_key

func _ready():
	fishListInstance = fishListScene.instance()
	fishListInstance.connect("close", self, "close_menu")
	fishListInstance.connect("key_created", self, "key_created")
	add_instance_with_name(fishListInstance, "fish list")

func _on_3DPickable_picked(_picker):
	_picker.switch(false)
	open_instance("fish list")
	
func _on_OpenUpgradePickable_picked(_picker):
	_picker.switch(false)
	open_instance("ShipHeartUpgradeScene")
	
func _on_InteractableComponent_interact_closed(_player):
	close_menu()

func _on_ShipHeart_ship_resource_out(shipResource : ShipResource):
	if fishListInstance:
		fishListInstance.fishCaptureResource = shipResource.fishCaptureResource

func key_created(keyInstance):
	emit_signal("emit_key", keyInstance)

func _on_ShipHeart_upgrade_collection_out(upgradeCollection):
	set_instance_property("ShipHeartUpgradeScene", "upgradeCollection", upgradeCollection, "VBoxContainer/UpgradeCollectionScene")

func _on_ShipHeart_save_game_out(saveGame):
	set_instance_property("ShipHeartUpgradeScene", "inventoryResource", saveGame.playerResource.inventoryResource, "VBoxContainer/Inventory")
