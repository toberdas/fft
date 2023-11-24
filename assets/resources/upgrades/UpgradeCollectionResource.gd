extends Resource
class_name UpgradeCollectionResource

export(Array, Resource) var upgradeList = []
export(String, MULTILINE) var label = "Realize slimeball potential"

func get_upgrade(upgradeName):
	for upgrade in upgradeList:
		if upgrade.name == upgradeName:
			return upgrade
	return null

func get_upgrade_progress(upgradeName):
	var upgrade : UpgradeResource = get_upgrade(upgradeName)
	if upgrade:
		var progress = upgrade.get_progress()
		return progress
	return null

func get_upgrade_progress_ratio(upgradeName):
	var upgrade : UpgradeResource = get_upgrade(upgradeName)
	if upgrade:
		var progress = upgrade.get_progress_ratio()
		if progress:
			return progress
	return null
	
func get_upgrade_explained_progress():
	pass
