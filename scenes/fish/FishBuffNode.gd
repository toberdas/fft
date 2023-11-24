extends BuffNode



func _on_ResponseNode_buff_out(buff):
	add_buff(buff)

func _on_FishAttackNode_buff_out(buff):
	add_buff(buff)

func _on_Fish_fishready(fish):
	buffCollection = fish.fishData.buffCollection
