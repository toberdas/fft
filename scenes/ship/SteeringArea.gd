extends Area


func check_if_player_in_area():
	for body in get_overlapping_bodies():
		if body.is_in_group("Player"):
			return true
