extends Menu #the main fishtalk scene, handles input and controls the talking and minigaming

export(NodePath) var nameLabel
onready var fish_face = $MarginContainer/FishFace
onready var background = $Background
onready var animation_player = $AnimationPlayer


export(bool) var DEBUG = false

var fishData : FishData

onready var welcomeRuleSet = preload("res://assets/replacementrules/sets/LookAtSet.tres")
onready var memoryRuleSet = preload("res://assets/replacementrules/sets/LookAtSet.tres")
const fishTalkDialogScene = preload("res://scenes/ui/fishtalkui/FishTalkDialog.tscn")
const fishTalkGameScene = preload("res://scenes/ui/fishtalkui/FishTalkGame.tscn")
const fishTalkMemoryScene = preload("res://scenes/fish/FishMemoryScene.tscn")
var fishTalkWelcome = null
var fishTalkMemory = null
var fishTalkGame = null



signal prompt_accepted
signal gaming_done
signal playerwon
signal talkover
signal ask_for_motif

func _ready(): #setup stuff, making a replacementgrammer node child and initializing reference to textlabel
	if !fishData:
		randomize()
		fishData = FishData.new()
		fishData.generate()
	nameLabel = get_node(nameLabel)
	fish_face.run(fishData)
	background.set_colors(fishData.color)
	nameLabel.text = fishData.brain.character.fishName

	fishTalkWelcome = create_screen_instance_from_scene(fishTalkDialogScene)
	fishTalkMemory = create_screen_instance_from_scene(fishTalkMemoryScene)
	fishTalkGame = create_screen_instance_from_scene(fishTalkGameScene)

	fishTalkWelcome.ruleSet = welcomeRuleSet
	fishTalkMemory.ruleSet = memoryRuleSet

	add_instance_with_name(fishTalkWelcome, "welcome")
	add_instance_with_name(fishTalkGame, "game")
	add_instance_with_name(fishTalkMemory, "memory")
	animation_player.play("intro")



func init(_fishdata):
	fishData = _fishdata

func start():
	$MotifPlayer.play_motif(fishData.motif)
	
	open_menu()

func switch_screen(targetKey):
	switch_instance_open(targetKey)
#	$MotifPlayer.play_motif(fishData.motif)

func exit_talk():
	emit_signal("talkover", fishData.gameWon)
	queue_free()

func create_screen_instance_from_scene(scene):
	var screenInstance = scene.instance()
	screenInstance.fishData = fishData
	screenInstance.connect("switch_screen_out", self, "switch_screen")
	screenInstance.connect("exit_talk", self, "exit_talk")
	return screenInstance

func get_memories():
	var txt = ''
	for memory in fishData.brain.memory.memories:
		txt += memory.text
	return txt



