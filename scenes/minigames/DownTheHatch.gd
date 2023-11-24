extends MiniGame

export var slowMult = 0.1
export var curveStep = 0.01
export var pathThickness = 12
export var maxGrav = 5


const shapeCollection = preload("res://scenes/minigames/DownTheHatchShapes.tscn")

#control vars
var pointList = PoolVector2Array()
var curveInt = 0
var speed = 0
var velocity = Vector2(0,0)

onready var fishBody = $FishBody

func _ready():
	var myShapes = shapeCollection.instance()
	add_child(myShapes)
	var myShape = myShapes.pick_shape()
	construct_walls(myShape)

func set_colors(color):
	$FishBody/FishSprite.modulate = color.lightened(0.4)
	$BGSprite.modulate = color.darkened(0.4)

func playScript(delta):
	if curveInt <= 1:
			curveInt += .01
	else:
		curveInt = 0
	var hookspeed = hookData["hookSpeed"] * 10
	var hdir = int(Input.is_action_pressed("moveright")) - int(Input.is_action_pressed("moveleft"))
	var vdir = int(Input.is_action_pressed("camdown")) - int(Input.is_action_pressed("camup"))
	var fishimp = (fishData["fishSize"] + fishData["speed"]) * (fishData["fishCurve"].interpolate(curveInt) - 0.5)
	$FishBody/FishSprite.set_rotation(-fishimp)
	var impulse = ((hdir * hookspeed * 10) + (20 * fishimp)) * delta
	speed = lerp(speed, speed + impulse, 5 * delta)
	speed = clamp(speed, -5.0, 5.0)
	$FishBody/HookNode.set_rotation(-speed * 0.8)
	var vel = $FishBody/HookNode.transform.y * (20 * vdir + 40)
#	fishBody.move_and_collide(Vector2(speed, ))
	fishBody.move_and_collide(vel * delta)


func construct_walls(polygon2d:Polygon2D):
	var polygon = polygon2d.polygon
	var endPolygon = polygon2d.get_node("Polygon2D").polygon
	$PathArea/CollisionPolygon2D.polygon = polygon
	$Area2D/CollisionPolygon2D.polygon = endPolygon
	

func _on_PathArea_body_exited(_body):
	if currentState != STATE.LOSE && currentState == STATE.PLAY:
		lose()

func _on_Area2D_body_entered(_body):
	if currentState != STATE.WIN && currentState == STATE.PLAY:
		win()
