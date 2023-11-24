extends Spatial

signal mover_out
signal expression_out
signal buff_out

func _on_FishBrainNode_response_out(responseInstance : ResponseInstance):
	make_mover_from_response_and_emit(responseInstance)
	emit_expression_from_response(responseInstance)
	emit_buffs_from_response(responseInstance.response)

func make_mover_from_response_and_emit(responseInstance : ResponseInstance):
	var moverResource = responseInstance.response.moverResource
	if moverResource:
		var moverInstance = MoverInstance.new()
		moverInstance.moverResource = moverResource
		moverInstance.time = moverResource.time
		moverInstance.body = responseInstance.body
#		var mover = response.moverResource.duplicate()
#		mover.node = response.body
		emit_signal("mover_out", moverInstance)

func emit_expression_from_response(responseInstance : ResponseInstance):
	var responseResource = responseInstance.response
	for expression in responseResource.expressionOutcomes:
		emit_signal("expression_out", expression, responseInstance.body)

func emit_buffs_from_response(response):
	for buff in response.buffs:
		emit_signal("buff_out", buff)
