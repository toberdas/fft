extends Resource
class_name BuffCollection

var buffs = []

func remove_buff(buff):
	buffs.erase(buff)

func remove_buff_by_name(buffname):
	for buff in buffs:
		if buff.name == buffname:
			remove_buff(buff)

func get_buff(property):
	var value = 0.0
	for buff in buffs:
		if buff.property == property:
			value += buff.strength
	return value

func add_buff(fishbuff : Buff):
	var dupe = fishbuff.duplicate()
	buffs.append(dupe)
