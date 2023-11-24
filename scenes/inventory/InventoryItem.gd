extends SteeringAgent2D
class_name InventoryItem

var time = 0.0
var itemID = ""

var itemResource setget set_resource
var pickupItemResource : PickupItemResource setget set_pickup_resource

var inventory = null
var flowField = null
var cursor = null

var equipSlot = null
var centerPoint = Vector2.ZERO setget set_centerpoint

var pickedUp = false

signal picked_up
signal dropped

func _ready():
	flowField = FlowField.new()
	if centerPoint != Vector2.ZERO:
		global_position = centerPoint

func _enter_tree():
	if centerPoint != Vector2.ZERO:
		global_position = centerPoint

func _process(delta):
	var zfac = (z_index + 1)
#	scale = Vector2.ONE + (Vector2(.1,.1) * zfac)
	time += delta
	if !get_parent() is TwoDPointer && !equipSlot:
		if flowField:
			add_force(flow_time(flowField, time * 10) * (delta))
			if centerPoint != Vector2.ZERO:
				var centerVel = centerPoint.distance_to(global_position)
				add_force(seek(centerPoint, 200) * (centerVel / 20))
		if cursor && cursor.rummaging:
			var cp = cursor.global_position
			add_force(flee(cp, 200) * (2.0 * (zfac*10)))
		var _err = move_and_collide(velocity)
	if equipSlot:
		global_position = equipSlot.global_position

func set_resource(_ir : Item):
	itemResource = _ir
	$UIFocusable.tooltipString = _ir.toolTip
	$UIFocusable.nameString = _ir.itemName
	$Sprite.texture = _ir.icon
	$Sprite.modulate = itemResource.iconModulate

func set_pickup_resource(pickupResource : PickupItemResource):
	pickupItemResource = pickupResource
	centerPoint = pickupItemResource.centerPoint
	set_resource(pickupResource.itemResource)

func set_centerpoint(newcenterpoint):
	centerPoint = newcenterpoint
	if pickupItemResource:
		pickupItemResource.centerPoint = newcenterpoint

func unequip():
	equipSlot = null
	pickupItemResource.inEquip = false

func equip(slot):
	equipSlot = slot
	pickupItemResource.equip()

func destroy():
	pickupItemResource.destroy()
	queue_free()
