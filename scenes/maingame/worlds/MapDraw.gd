extends Control

#onready var worldMap = preload("res://assets/resources/saving/worldMap.tres")
#
#func _process(delta):
#	update()
#
#func _notification(what):
#	if what == NOTIFICATION_DRAW:
#		for point in worldMap.points:
#			draw_circle(point * rect_size, 6, Color.blueviolet)
#
#func _draw():
#	for point in worldMap.points:
#		draw_circle(point * rect_size, 6, Color.blueviolet)
#	if GlobalSingleton.player:
#		var po = GlobalSingleton.player.global_transform.origin
#		po = Vector2(po.x, po.z)
#		var lp = po.posmodv(GameplayConstants.worldSize) / GameplayConstants.worldSize
#		draw_circle(lp * rect_size, 4, Color.black)
	
