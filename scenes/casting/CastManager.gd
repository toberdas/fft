extends Node

export(NodePath) var castPoint
export(PackedScene) var defaultCast
export var debug = false;

var equipResource : EquipResource
var maxCasts = 2
var currentCastScenes = []

signal fish_caught
signal fish_lost
signal fish_hooked
signal thrown
signal cast_cleared
signal nibble
signal ignore_nibble
signal reelin
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
			var ccs = defaultCast.instance()
			ccs.castResource = castResource
			connect_and_add(ccs)
	if debug:
		if castPoint.get_child_count() < maxCasts:
			var ccs = defaultCast.instance()
			connect_and_add(ccs)

func create_cast_resource_connected():
	var castResource = CastResource.new()
	castResource.connect("cast_done")
	castResource.connect("cast_failed")
	castResource.connect("cast_start")
	castResource.connect("fish_hooked")
	castResource.connect("fish_nibbled")
	castResource.connect("fish_reeled_in")
	castResource.connect("predict_start")
	return castResource

func connect_and_add(instance):
	currentCastScenes.append(instance)
	instance.connect("cast_freed", self, "clear_cast")
	instance.connect("throw", self, "emit_signal", ["thrown"])
	instance.connect("fish_hooked", self, "hooked_fish")
	instance.connect("fish_caught", self, "emit_signal_custom", ["fish_caught"])
	instance.connect("fish_lost", self, "emit_signal_custom", ["fish_lost"])
	instance.connect("nibble", self, "emit_signal_custom", ["nibble"])
	instance.connect("ignore_nibble", self, "emit_signal_custom", ["ignore_nibble"])
	instance.connect("tree_exiting", self, "remove_instance", [instance])
	castPoint.add_child(currentCastScenes[-1])

func remove_instance(instance):
	currentCastScenes.erase(instance)

func hooked_fish(fish):
	equipResource.remove_slot_pickup("BaitSlot")
	emit_signal("fish_hooked", fish)

func clear_cast(castNode):
	emit_signal("cast_cleared")
#	currentCastScenes.erase(castNode)

func _on_Player_startpredict():
	cast()

func emit_signal_custom(fish, name):
	emit_signal(name, fish)

func _on_Player_reelin():
	if currentCastScenes.size() > 0:
		var castNode = currentCastScenes.back().castNode
		if castNode:
			if !castNode.casting: 
				var sumPoint = average_all_cast_bobbers_origins()
				emit_signal("reelin", sumPoint)
				for ccs in currentCastScenes:
					ccs.queue_free()
				currentCastScenes = []
				emit_signal("cast_cleared")

func average_all_cast_bobbers_origins():
	var point = Vector3.ZERO
	var i = 0
	for castscene in currentCastScenes:
		point += castscene.castNode.castbobber.global_transform.origin
		i += 1
	return point / i


func _on_Player_player_resource_ready(playerResource):
	equipResource = playerResource.equipResource