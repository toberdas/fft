extends BuffNode

func check_if_item_has_buffs(item : Item):
	return item.buffArray.size() > 0

func get_item_buffs(item):
	return item.buffArray

func add_buffs_from_item(item : Item):
	if check_if_item_has_buffs(item):
		for buff in get_item_buffs(item):
			add_buff(buff)

func remove_buffs_of_item(item : Item):
	if check_if_item_has_buffs(item):
		for buff in get_item_buffs(item):
			remove_buff_by_name(buff.name)

func _on_Player_player_resource_ready(playerResource):
	buffCollection = playerResource.buffCollection


func _on_InventoryManager_item_equiped_out(item:Item):
	add_buffs_from_item(item)


func _on_InventoryManager_item_unequiped_out(item:Item):
	remove_buffs_of_item(item)
