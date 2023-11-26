extends Resource
class_name IslandCharacter

var islandResource = null

var islandTaste = ''
var power = 0.5
var unity = 0.5
var density = 0.5
var dynamic = 0.5
var scale = 0.5
var tier = 1
var height = 0.5
var amount = 0.5
var instruments = [preload("res://assets/resources/music/instruments/A1_Dungeon.tres"), preload("res://assets/resources/music/instruments/A2_Dungeon.tres"), preload("res://assets/resources/music/instruments/A3_bubble.tres")]


var	cellularDepth = 0
var	cellularHeight = 0
var	cellularAmount = 0
var cellularGenerations = 0
var cellularFilltype
var cellularRule = 0

var fishAmount = 0

var interactableAmount = 0

var hasTreasure = false
var treeChance = 0.0

var characterTagSet = null

func _init(_tier = 1, ir = null):
	islandResource = ir
	tier = _tier
	run()

func run():
	power = randf()
	unity = randf()
	density = randf()
	amount = randf()
	dynamic = randf()
	scale = 6.0
	height = (.5 + randf() * 0.5) * GameplayConstants.maxHeight
	islandTaste = HelperScripts.random_var_from_dict(GameplayConstants.baitTastes)
	make_cellural_members()
	make_fish_members()
	make_doodad_members()
	characterTagSet = TagSet.new()
	characterTagSet.make_tagset_from_enum(FishEnums.charactertags)
	
func make_cellural_members():
	var total = 16 + (tier * 2)
	var rand = rand_range(0.5,0.9)
	cellularHeight = int(rand * total)
	cellularDepth = int((1.0 - rand) * total)
	cellularAmount = 6 + tier
	cellularGenerations = 4 + randi() % tier
	cellularRule = randi() % CellularAutomataData.presetArray.size()
	print_debug("Using rule " + str(cellularRule))

func make_fish_members():
	fishAmount = 3 + tier * 2

func make_doodad_members():
	treeChance = randf()
	if tier >= 3:
		hasTreasure = true
