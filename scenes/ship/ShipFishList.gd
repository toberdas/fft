extends Control

var fishCaptureResource : FishCaptureResource setget set_capture_resource
signal fishCaptureOut

signal close
signal key_created

func _enter_tree():
	emit_signal("fishCaptureOut", fishCaptureResource)

func _ready():
	emit_signal("fishCaptureOut", fishCaptureResource)
	
func set_capture_resource(_fishCaptureResource):
	fishCaptureResource = _fishCaptureResource
	emit_signal("fishCaptureOut", fishCaptureResource)

func _on_Ship_ship_loaded(shipResource : ShipResource):
	set_capture_resource(shipResource.fishCaptureResource)


func _on_ExitButton_pressed():
	emit_signal("close")


func _on_KeyMaker_key_created(keyInstance):
	emit_signal("key_created", keyInstance)
	emit_signal("close")
