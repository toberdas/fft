extends MiniGame

export(float) var fishStepTime
export(float) var fishStepTimeVariance
export(int) var stepTotal
export(float) var stepDistance 

var raceStarted = false

func _ready():
	$FinishLine.position.y = -stepTotal * stepDistance

func _unhandled_input(event):
	if raceStarted:
		if Input.is_action_just_pressed("a"):
			$You.step()
			check_steps($You)

func start_race():
	raceStarted = true
	$Timer.start(fishStepTime + rand_range(-fishStepTimeVariance, fishStepTimeVariance))
	$You.race_start()
	$Fish.race_start()
	
func check_steps(contestant):
	if contestant.stepCount >= stepTotal:
		declare_winner(contestant)

func declare_winner(contestant):
	contestant.win()
	if contestant == $You:
		win()
	if contestant == $Fish:
		lose()
	raceStarted = false

func _on_Timer_timeout():
	if raceStarted:
		$Fish.step()
		check_steps($Fish)

func _on_StartTimer_timeout():
	start_race()
