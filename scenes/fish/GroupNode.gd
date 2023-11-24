extends ExpressionReceiverNode

func _ready():
	myExpression = "get scary"

func run():
	get_parent().add_to_group("ScaryToFish")
	$Timer.start(2.0)


func _on_Timer_timeout():
	if get_parent().is_in_group("ScaryToFish"):
		get_parent().remove_from_group("ScaryToFish")

