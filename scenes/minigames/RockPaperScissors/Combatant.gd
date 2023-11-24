extends Node2D

var rockPaperScissors = [
	preload("res://assets/img/icons/hands/rockHand.png"),
	preload("res://assets/img/icons/hands/paperHand.png"),
	preload("res://assets/img/icons/hands/scissorHand.png")
]
export(NodePath) var hand
export(NodePath) var upNode
export(NodePath) var middleNode
export(NodePath) var downNode

var currentHand = preload("res://assets/img/icons/hands/rockHand.png") setget set_current_hand
var targetNode = null
var count = 0
var wasUp = false
var secretHandIndex = 0

func _ready():
	hand = get_node(hand)
	upNode = get_node(upNode)
	middleNode = get_node(middleNode)
	downNode = get_node(downNode)

func _process(delta):
	if targetNode:
		hand.position = lerp(hand.position, targetNode.position, delta * 10)

func move_up():
	targetNode = upNode
	wasUp = true
	set_current_hand(rockPaperScissors[0])

func move_down():
	targetNode = downNode
	if wasUp:
		count += 1
	if count == 3:
		show_hand()
	wasUp = false
#
#func move_middle(delay = 0.0):
#	if delay > 0.0:
#		yield(get_tree().create_timer(delay), "timeout")
#	targetNode = middleNode
#	hand.get_node("Sprite").texture = rockPaperScissors[0]

func show_hand():
	set_current_hand(rockPaperScissors[secretHandIndex])
	count = 0

func set_current_hand(val):
	currentHand = val
	hand.get_node("Sprite").texture = currentHand
