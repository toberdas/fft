extends Spatial

var lootResource = null

var itemList = []

func populate_loot(lootTable):
	if lootTable:
		for itemResource in lootTable:
			if !itemResource.pickedUp:
				var item = ItemData.create_3d_item_from_resource(itemResource)
				add_child(item)
				item.global_transform.origin = global_transform.origin

func despawn_items():
	for itemChild in get_children():
		itemChild.queue_free()

func spawn_3d_item_from_resource(itemResource):
	if !itemResource.pickedUp:
		var item = ItemData.create_3d_item_from_resource(itemResource)
		return item
