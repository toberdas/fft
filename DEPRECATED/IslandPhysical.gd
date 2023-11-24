extends Node
class_name IslandPhysical

var rockAmount = 0
var rockDict = {}
var elements = {}
var toInstance = {'surfaces' : [], 'cliffs' : [], 'beach' : [], 'doodads' : [], 'platforms' : []}
var connections = []
var beach = null
var seedPoint = Vector2(0.5, 0.5)

func _init(character = IslandCharacter.new()):
	character.physical = self
	run(character)

func run(character):
	rockAmount = 0
	rockDict = {}
	make_rock_amount(character.tier)
	place_rocks(character.unity)
	make_seedpoint()
	make_rocks(character, seedPoint)
	make_connections(character)
	beach = Beach.new(seedPoint, character)

func make_rock_amount(tier = 1):
	rockAmount = max(1, randi() % GameplayConstants.rockAmounts[tier])

func place_rocks(unity = 0.5):
	var d = Dice.new()
	d.add_die(6)
	d.add_die(6)
	d.add_die(6)
	var am = 0
	var c1 = 0
	while am < rockAmount and c1 < 200:
		c1 += 1
		var c = 0
		var rp = Vector2(d.throw_all(true), d.throw_all(true))
		while !check_rock(rp, (1.0 - unity) * .4) and c < 200:
			c +=1
			rp = Vector2(d.throw_all(true), d.throw_all(true))
		rockDict[rp] = 0
		am += 1

func check_rock(pos, dist):
	for rock in rockDict.keys():
		var l = (rock - pos).length()
		if l < dist:
			return false
	return true

func make_seedpoint():
	var tp = Vector2.ZERO
	var c = 1
	for key in rockDict:
		tp += key
		c += 1
	seedPoint = tp / c

func make_rocks(character, seedPoint):
	var first = true
	for key in rockDict.keys():
		rockDict[key] = Rock.new(key, character, seedPoint, first)
		first = false

func make_connections(character):
	var desperate = false
	connections = []
	var freeKeys = rockDict.keys()
	var maxTries = 300
	var try = 0
	var currentKey = freeKeys[randi() % freeKeys.size()]
	freeKeys.erase(currentKey)
	while freeKeys.size() != 0  && try < maxTries:
		try += 1
		var c = Connection.new()
		var nk = c.try(rockDict, currentKey, desperate)
		if nk:
			freeKeys.erase(currentKey)
			currentKey = nk
			connections.append(c)
			c.run(character)
			desperate = false
		else:
			currentKey = freeKeys[randi() % freeKeys.size()]
			freeKeys.erase(currentKey)
			desperate = true
