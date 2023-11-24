extends Node
class_name BuffNode

var buffCollection : BuffCollection

func _process(delta):
	if buffCollection:
		decay_buffs(delta)

func decay_buffs(delta):
	for buff in buffCollection.buffs:
		if !buff.infinite:
			buff.duration -= delta
			if buff.duration <= 0:
				buffCollection.remove_buff(buff)

func remove_buff(buff):
	buffCollection.remove_buff(buff)

func remove_buff_by_name(buffname):
	buffCollection.remove_buff_by_name(buffname)

func get_buff(property):
	if buffCollection:
		return buffCollection.get_buff(property)
	else:
		return 0.0

func add_buff(buff):
	buffCollection.add_buff(buff)
