extends Node


var combiAmount = 0.0 setget ,get_combi_amount
var maxCombiAmount = 2.0
var combiTimer = .6

func get_combi_amount():
	if combiAmount && maxCombiAmount:
		return combiAmount/maxCombiAmount
	else:
		return 1.0

func _on_Player_landed():
	if combiAmount < maxCombiAmount:
		combiAmount += 1.0
	else:
		combiAmount = 0.0
	$Timer.wait_time = combiTimer
	$Timer.start()

func _on_Timer_timeout():
	combiAmount = 0

func _on_Player_jumped():
	$Timer.stop()
