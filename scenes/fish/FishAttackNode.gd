extends ExpressionReceiverNode

signal start_attack
signal attacked
signal buff_out
signal release_pressure_from_attack
signal food_eaten

var attacking = false
var targetBody = null 

export(Resource) var attackBuff

func _ready():
	myExpression = "attack"
	needsBody = true

func start_attack(body):
	switch_on()
	targetBody = body
	attacking = true
	$Timer.start(4.0)
	

func stop_attack():
	switch_off()
	attacking = false
	targetBody = null
	
func _on_Area_body_entered(body):
	if body != get_parent():
		if body == targetBody:
			attack()

func attack():
	play_attack_animation()
	stop_attack()
	emit_signal("buff_out", attackBuff)

func play_attack_animation():
	$AnimationPlayer.play("attack")

func set_detect_area_monitoring(boo):
	$DetectArea.set_deferred('monitoring', boo)

func switch_off():
	set_detect_area_monitoring(false)

func switch_on():
	set_detect_area_monitoring(true)

func run_with_body(body):
	start_attack(body)


func _on_AttackingNode_body_attacked(body):
	if is_instance_valid(body):
		if body.is_in_group("Food"):
			emit_signal("food_eaten", body)
	emit_signal("release_pressure_from_attack")


func _on_Timer_timeout():
	stop_attack()
