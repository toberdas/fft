extends Node

export(Resource) var potentialUpgrades
var currentUpgrades = {} #upgrades are grouped by part of the ship it pertains to, this way these parts can easily lookup if there are relevant upgrades.
var upgradeIndex = 0

func get_relevant_upgrades(nodename):
	if currentUpgrades.has(nodename):
		return currentUpgrades[nodename]
	else:
		return {}

func add_next_upgrade():
	if potentialUpgrades.upgradeArray.size() > upgradeIndex:
		var upg = potentialUpgrades.upgradeArray[upgradeIndex]
		if currentUpgrades.has(upg.shipPart):
			currentUpgrades[upg.shipPart].merge({upg.upgradeName : upg.upgradeParamaters})	
		else:
			currentUpgrades[upg.shipPart] = {}
			currentUpgrades[upg.shipPart].merge({upg.upgradeName : upg.upgradeParameters})	
		upgradeIndex += 1

func _on_ShipFlockManager_flock_filled():
	add_next_upgrade()
