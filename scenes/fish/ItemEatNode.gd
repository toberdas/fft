extends Spatial



func _on_ItemSenseNode_item_sensed(itemBody):
	eat_item(itemBody.owner)

func eat_item(item):
	item.queue_free()
