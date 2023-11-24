extends Node


export(Resource) var upgradeResource


# Called when the node enters the scene tree for the first time.
func _ready():
	$UpgradeScene.upgradeCollection = upgradeResource
	$UpgradeScene.open_and_add_upgrades()
