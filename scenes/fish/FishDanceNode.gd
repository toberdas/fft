extends ExpressionReceiverNode

signal do_dance

func _ready():
	myExpression = "dance"

func run():
	emit_signal("do_dance")
