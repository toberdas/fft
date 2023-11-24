extends HBoxContainer

var activeFragmentCount

func _on_KeyMaker_fragment_added(save : FishSave):
	add_fragment_from_fishdata_and_count(save)

func add_fragment_from_fishdata_and_count(save : FishSave):
	var count = 0
	for fragment in get_children():
		if fragment is Fragment:
			if fragment.check_if_activated():
				count += 1
			else:
				fragment.activate(save)
				return

func check_if_fragment_present(fishItem):
	for fragment in get_children():
		if fragment is Fragment:
			if fragment.compare_fish_item(fishItem):
				return true
	return false

func check_if_fragments_full():
	var count = 0
	for fragment in get_children():
		if fragment is Fragment:
			if fragment.check_if_activated():
				count += 1
	
	if count == 3:
		return true
	else:
		return false

func get_combined_color():
	var color = Color(1,1,1,1)
	for fragment in get_children():
		if fragment is Fragment:
			color = color.linear_interpolate(fragment.get_fish_color(), 0.5)
	return color

func key_forged():
	set_all_fragments_acquiered()
	clear_all_fragments()

func set_all_fragments_acquiered():
	for fragment in get_children():
		if fragment is Fragment:
			fragment.set_acquiered()

func clear_all_fragments():
	for fragment in get_children():
		if fragment is Fragment:
			fragment.clear()
