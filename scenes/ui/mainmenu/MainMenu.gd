extends Control

signal new_game
signal continew

func _on_NewGameButton_pressed():
	emit_signal("new_game")

func _on_ContinueButton_pressed():
	emit_signal("continew")
