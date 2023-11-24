extends MiniGame

var desiredVelocity = Vector2()
var velocity = Vector2()
var maxSpeed = 1
var maxForce = 1
var acceleration = Vector2()
var mass = .2

var hookSpeed = 0.0

export var slowMult = 0.6
var speedMult = 1

var curveInt = 0
var overlapping = false

onready var fishFollow = $Path2D/FishFollow
onready var hookFollow = $Path2D/HookFollow
onready var fishArea = $Path2D/FishFollow/FishArea
onready var hookArea = $Path2D/HookFollow/HookArea
onready var wheelAnims = $WheelAnimationPlayer

#func _ready():
#	start_game()
	
func set_colors(color):
	$CircleSprite.modulate = color.darkened(0.3)
	$Path2D/FishFollow/FishArea/Sprite.modulate = color.lightened(0.4)

func playScript(delta):
	if curveInt <= 1:
		curveInt += .01
	else:
		curveInt = 0
	fishFollow.unit_offset += fishData.fishCurve.interpolate(curveInt) * delta * speedMult
	hookFollow.unit_offset -= hookSpeed * delta * speedMult
	hookSpeed = lerp(hookData.hookSpeed, 0, hookData.hookDrag * delta)
	
	if Input.is_action_just_pressed("action"):
		wheelAnims.play("hook")
		if overlapping:
			hookSpeed += hookData.hookAcceleration
			wheelAnims.play("hit")
			fish_hit(1)
		else:
			fish_miss(1)
			hookSpeed -= min(hookSpeed, hookData.hookBrake)
			wheelAnims.play("miss")

func _on_HookArea_area_entered(_area):
	speedMult = slowMult
	overlapping = true

func _on_HookArea_area_exited(_area):
	speedMult = 1
	overlapping = false
