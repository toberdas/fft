extends Spatial

signal parent_to
signal unparented

var worldParent = null
var currentParentArea = null
var cooldown = 60
var myOwner = null
var lastPosition : Vector3

var graceFrameCounter = 0
var graceFrames = 12

func check_if_ground_solid():
	if currentParentArea:
		if currentParentArea.is_in_group("Solid ground"):
			return true
		else:
			return false
	return true

func _ready():
	myOwner = owner
	worldParent = owner.get_parent()

func _process(_delta):
	var count = 0
	if cooldown > 0: 
		cooldown -= 1
	else:
		var areas = $Area.get_overlapping_areas()
		if areas.size() > 0:
			var collider = get_most_important_area(areas)
			if collider != currentParentArea:
				currentParentArea = collider
				currentParentArea.parented(myOwner)
				HelperScripts.switch_parent_keep_transform(myOwner, collider.targetParent)
				emit_signal("parent_to", collider.targetParent)
				cooldown = collider.timeOutFramesWhenLeavingParent
				return
			else:
				graceFrameCounter = 0
		else:
			graceFrameCounter += 1
			if graceFrameCounter >= graceFrames:
				if currentParentArea != null:
					currentParentArea.unparented(myOwner)
					HelperScripts.switch_parent_keep_transform(myOwner, worldParent)
					emit_signal("parent_to", worldParent)
					emit_signal("unparented", global_transform.origin - lastPosition)
					currentParentArea = null
					graceFrameCounter = 0
	lastPosition = global_transform.origin

func get_most_important_area(areas):
	var currentArea = areas[0]
	for parentArea in areas:
		if parentArea.importance > currentArea.importance:
			currentArea = parentArea
	return currentArea
