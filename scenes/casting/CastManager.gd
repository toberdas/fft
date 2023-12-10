extends Node

export(NodePath) var castPoint
export(PackedScene) var defaultCast
export var debug = false;

const castScene = preload("res://scenes/casting/CastScene.tscn")

var equipResource : EquipResource
var maxCasts = 2
var currentCastScenes = []

signal fish_caught
signal fish_lost
signal fish_hooked
signal thrown
signal cast_cleared
signal nibble
signal reeljump
signal ignore_nibble
signal start_cast

func _ready():
	castPoint = get_node(castPoint)

func cast():
	var boo = ConditionCheck.check_from_root(preload("res://scenes/maingame/player/OnSolidGround.tres"), get_parent().get_parent())
	if !boo:
		Warning.new(preload("res://scenes/ui/warnings/FishOnSolidGround.tres"))
		return
	var castResource = create_cast_resource_connected()
	castResource.equipResource = equipResource
	emit_signal("start_cast")
	var baitPickupItem = equipResource.get_slot_pickup("Bait")
	var rodPickupItem = equipResource.get_slot_pickup("Rod")
	if baitPickupItem && rodPickupItem:
		if castPoint.get_child_count() < maxCasts:
			var ccs = castScene.instance()
			ccs.castResource = castResource
			connect_and_add(ccs)
	if debug:
		if castPoint.get_child_count() < maxCasts:
			var ccs = castScene.instance()
			ccs.castResource = castResource
			connect_and_add(ccs)

func create_cast_resource_connected():
	var castResource = CastResource.new()
	castResource.connect("cast_stopped", self, "clear_cast")
#	castResource.connect("cast_failed")
	castResource.connect("cast_start", self, "emit_signal", ["thrown"])
	castResource.connect("fish_hooked", self, "hooked_fish")
	castResource.connect("fish_nibbled", self, "fish_nibbled")
	castResource.connect("fish_reeled_in", self, "fish_is_caught")
	castResource.connect("nibble_ignored", self, "nibble_ignored")
	castResource.connect("fish_got_away", self, "lost_fish")
#	castResource.connect("predict_start")
	return castResource

func connect_and_add(instance):
	currentCastScenes.append(instance)
	instance.connect("cast_freed", self, "clear_cast")
	instance.connect("tree_exiting", self, "remove_instance", [instance])
	castPoint.add_child(currentCastScenes[-1])

func remove_instance(instance):
	currentCastScenes.erase(instance)

func hooked_fish(fish):
	emit_signal("fish_hooked", fish)

func fish_nibbled(fish):
	emit_signal("nibble", fish)

func fish_is_caught(fish):
	emit_signal("fish_caught", fish)

func nibble_ignored(fish):
	emit_signal("ignore_nibble", fish)

func lost_fish(fish):
	emit_signal("fish_lost", fish)

func clear_cast(castNode):
	emit_signal("cast_cleared")
#	currentCastScenes.erase(castNode)

func _on_Player_startpredict():
	cast()

func emit_signal_custom(fish, name):
	emit_signal(name, fish)

func reel_jump():
	if currentCastScenes.size() > 0:
		var castNode = currentCastScenes.back().castNode
		if castNode:
			if !castNode.casting: 
				var sumPoint = average_all_cast_bobbers_origins()
				for ccs in currentCastScenes:
					ccs.queue_free()
				currentCastScenes = []
				return sumPoint

func average_all_cast_bobbers_origins():
	var point = Vector3.ZERO
	var i = 0
	for castscene in currentCastScenes:
		point += castscene.castNode.castbobber.global_transform.origin
		i += 1
	return point / i


func _on_Player_player_resource_ready(playerResource):
	equipResource = playerResource.equipResource


func _on_Player_ask_for_reeljump():
	emit_signal("reeljump", reel_jump())
