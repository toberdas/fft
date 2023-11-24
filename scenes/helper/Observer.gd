extends Spatial


var observed = null
var notifier = null
var inscreen = true

signal isout
signal isin

func _ready():
	pass # Replace with function body.


func _process(delta):
	if inscreen:
		emit_signal("isin", delta)
	else:
		emit_signal("isout", delta)

func start_observer(node):
	if node:
		if node.get_node('VisibilityNotifier'):
			node.get_node('VisibilityNotifier').connect("screen_entered", self, "in_screen")
			node.get_node('VisibilityNotifier').connect("screen_exited", self, "out_screen")

func in_screen():
	inscreen = true
	pass

func out_screen():
	inscreen = false
	pass
