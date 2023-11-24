extends Spatial


func _ready():
	set_as_toplevel(true)
	yield(get_tree().create_timer(1.0), "timeout")
	HelperScripts.switch_parent(self, get_parent().get_parent())

func _process(_delta):
	transform = Transform()
