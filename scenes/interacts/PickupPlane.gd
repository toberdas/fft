extends Area

func _ready():
	var _ce = connect("body_entered", self, "check_and_pick")

func check_and_pick(body):
	if body.get_parent().is_in_group("Item"):
		body.owner.pick_up()
