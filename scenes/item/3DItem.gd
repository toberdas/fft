extends Spatial
class_name ThreeDItem

var canBePickedUp = true
export(Resource) var itemResource setget set_resource
var itemID = ""
#var pickupResource : PickupItemResource setget set_pickup_resource

signal item_gone

func picked(_pickingPointer):
	emit_signal("item_gone")
	GlobalInventory.playerInventory.pickup_item(self)
	queue_free()

func set_resource(_ir):
	itemResource = _ir
	$Body/Sprite3D.texture = itemResource.icon
	$Body/Sprite3D.modulate = itemResource.iconModulate
	if _ir.get_type() == 'bait':
		set_as_food()

func dropped(from):
	from.get_tree().get_root().add_child(self)
	global_transform.origin = from.global_transform.origin + Vector3(0,2,0) + HelperScripts.random_vec3()
	apply_impulse(global_transform.origin - from.global_transform.origin)
	pass

func picked_up(pickupNode):
	emit_signal("item_gone")
	queue_free()

func apply_impulse(force):
	$Body.apply_central_impulse(force)

func freeze():
	set_body_mode(RigidBody.MODE_STATIC)

func unfreeze():
	set_body_mode(RigidBody.MODE_RIGID)

func set_body_mode(mode):
	$Body.mode = mode

func set_as_food():
	$Body/AttackableNode.add_to_group("Food")
	$Body.add_to_group("Food")


func _on_3DPickable_picked(_pickingPointer):
	picked(_pickingPointer)
