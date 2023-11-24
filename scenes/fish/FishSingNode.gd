extends ExpressionReceiverNode

signal sing

var cooldownTime = 1.0
var cooldown = 0.0

func _process(delta):
	if cooldown > 0.0:
		cooldown -= delta

func _ready():
	myExpression = "song"

func run():
	if cooldown <= 0.0:
		cooldown = cooldownTime + randf()
		emit_signal("sing")
