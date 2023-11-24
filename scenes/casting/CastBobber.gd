extends Spatial

var baitData = {}
var castResource : CastResource

onready var baitEmitter = $Bait/BaitEmitter
onready var hookEmitter  = $Hook/HookEmitter

var follow = null
var nibble = false

signal fishhooked
signal nibble
signal ignore_nibble

func _ready():
	var _ce = $Hook.connect("hook_fish", self, "fish_hooked")


func _process(_delta):
	if follow:
		global_transform.origin = follow.global_transform.origin

func _on_Casting_castdone():
	baitEmitter.switch_state("out") #start emitting when done casting *PROBABLY want to chagne this to start emitting when a command is hit, eventually
	hookEmitter.switch_state("out")

func change_parent(newparent):
	get_parent().remove_child(self)
	newparent.add_child(self)

func fish_hooked(fish):
	emit_signal("fishhooked", fish)

func _on_Hook_nibble(fish):
	castResource.nibblingFish = fish
	emit_signal("nibble", fish)

func _on_Hook_ignore_nibble(fish):
	castResource.nibblingFish = null
	emit_signal("ignore_nibble", fish)
