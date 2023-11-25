extends Spatial

signal body_attacked

func attack():
	for area in $AttackingArea.get_overlapping_areas():
		if area.get_parent().owner != owner:
			area.get_parent().attacked(self)
			if area.owner.owner:
				emit_signal("body_attacked", area.owner.owner)
			else:
				emit_signal("body_attacked", area.owner)
			
