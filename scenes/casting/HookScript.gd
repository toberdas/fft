extends Spatial

var nibble = false
var nibblingFish = null
var hooked = false

signal hook_fish
signal nibble
signal ignore_nibble

func _ready():
	var _ce = $HookEmitter.connect("body_entered", self, "fish_nibbled")

func _process(_delta):
	if Input.is_action_pressed("y") && nibble == true:
		nibble = false

func fish_nibbled(body):
	if body.is_in_group("Fish"): #check to see if you hit a fish
		if body.has_method("hooked") && !nibble: #check to see if the fish has a method when hit by the hook and if you havent already hooked a fish, to prevent hooking multiple fish
			nibble = true #set fishhooked to true so you cant hook more than 1 fish
			emit_signal("nibble", body)
			var _nibbleNode = TimedInput.new(preload("res://assets/resources/choices/FishNibbleChoice.tres"), self, "pull_nibble", "ignore_nibble")
			nibblingFish = body
			nibblingFish.nibble()

func pull_nibble(): #when the nibblenode returns succes
	emit_signal("hook_fish", nibblingFish)
	hooked = true

func ignore_nibble(): #when the nibblenode returns failure
	emit_signal("ignore_nibble", nibblingFish)
	nibblingFish.nibble_ignore()
	nibble = false

func _exit_tree(): #make sure to ignore when you stop angling
	if nibble && !hooked:
		ignore_nibble()
