extends MeshInstance
class_name InteractableComponent

var animDirection = 1

func _ready():
	HelperScripts.make_kinematic_collision(self, 4)
	
func run(_cursorState): #cursorstate is a dict that describes the interact cursor, it contains the heldItem
	run_animation(1)
	
func derun(_cursorstate):
	run_animation(-1)

func run_animation(direction):
	var animplayer = get_node("AnimPlayer")
	if animplayer:
		if animplayer.get_animation("1"):
			if animDirection == 1 && direction == 1:
				animplayer.current_animation = "1"
				animplayer.play("1")
				animDirection = -1
			if animDirection == -1 && direction == -1:
				animplayer.current_animation = "1"
				animplayer.play_backwards("1")
				animDirection = 1
			

