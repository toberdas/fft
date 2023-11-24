class_name TwoDPointer
extends TwoDPlayerMover

enum MODES{TWOD, THREED, BOTH, ALL}

export(MODES) var mode = MODES.TWOD

export(Texture) var actionIcon
export(Texture) var hoverIcon
export(Texture) var defaultIcon

export(NodePath) var area
export(NodePath) var sprite

export(int) var rayMask = 16
export(float) var rayDepth = 48.0
export(bool) var allowPicking = true

enum POINTERSTATE {DEFAULT, HOVER, ACTION}
var state = 0 setget set_state

signal picked

func _ready():
	area = get_node(area)
	sprite = get_node(sprite)
	
func _process(delta):
	var picked = get_pickable_under_mouse()
	if picked:
		set_state(POINTERSTATE.HOVER)
	else:
		set_state(POINTERSTATE.DEFAULT)
	
	if Input.is_action_just_pressed("a"):
		if picked:
			try_pick(picked)
	if Input.is_action_pressed("a"):
		set_state(POINTERSTATE.ACTION)
		
	override_process(delta)

func override_process(_delta): ##OVERRIDE
	pass

func get_pickable_under_mouse():
	var picked = null;
	if mode == MODES.TWOD:
		picked = check_under_mouse_2D()
	if mode == MODES.THREED:
		picked = check_under_mouse_3D()
	if mode == MODES.BOTH:
		picked = check_under_mouse_2D()
		if !picked:
			picked = check_under_mouse_3D()
	return picked

func try_pick(picked):
	emit_signal("picked", picked)
	if allowPicking:
		if picked is ThreeDPickable:
			picked.picked(self)
		if picked is TwoDPickable:
			picked.picked(self)
	action_on_picked(picked)

func action_on_picked(_picked): ##OVERRIDE
	pass

func pickup(item):
	pass

func check_under_mouse_2D():
	var ars = area.get_overlapping_areas()
	var rv = false
	if ars:
		for ar in ars:
			if ar is TwoDPickable:
				rv = ar
	return rv

func check_under_mouse_2D_in_group(ingroup = ""):
	var ars = area.get_overlapping_areas()
	var rv = false
	if ars:
		for ar in ars:
			if ar.is_in_group(ingroup):
				rv = ar
	return rv

func check_under_mouse_3D():
	var collider = shoot_ray(rayMask)
	if collider:
		return collider

func shoot_ray(mask = 0):
	var colliderDict = HelperScripts.ray_from_view(global_position, rayDepth, self, mask)
	if colliderDict:
		return colliderDict["collider"]

func set_state(_state):
	if _state == POINTERSTATE.DEFAULT:
		sprite.texture = defaultIcon
	if _state == POINTERSTATE.HOVER:
		sprite.texture = hoverIcon
	if _state == POINTERSTATE.ACTION:
		sprite.texture = actionIcon
	state = _state

func switch(on):
	if on:
		set_process(true)
		visible = true
	else:
		set_process(false)
		visible = false

func switch_mode(_mode):
	mode = _mode
