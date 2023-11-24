extends Spatial

signal pick_up_item

func _on_ItemSenseNode_item_sensed(itembody):
	var threeditem = itembody.owner
	if threeditem.canBePickedUp:
		itembody.owner.picked_up(self)
		emit_signal("pick_up_item", itembody.owner)
