extends PathFollow
class_name PathWalker
tool

export(bool) var auto = false
export(bool) var looping = false
export var walkSpeed = 12.0
export(Curve) var speedCurve
export(bool)var bounce = false

signal pathCompleted

var target = 0.0
var dir = 1

func _ready():
	target = get_parent().get_curve().get_baked_length()

func _process(delta):
	if auto:
		walk_path(delta)

func walk_path(delta):
	if looping:
		var off = get_offset() #get offset on parent path
		var ccl = get_parent().get_curve().get_baked_length() #get the total length of parent path's curve
		if offset != target: #if this isnt the full length of the curve yet
			var mult = 0
			if speedCurve:
				mult = speedCurve.interpolate_baked(offset/ccl)
			var sp = walkSpeed * (1 + mult) * delta * dir #sp is the speed with which the offset is added. speed is modified based on a curve
			offset = clamp(offset + sp, min(0, target), ccl)

			return false # returns false while path isnt complete	
		else: #if the follow has followed the whole path
			if bounce:
				dir = -dir
				if dir == -1:
					target = 0.0
				else:
					target = get_parent().get_curve().get_baked_length()
				
			else:
				set_unit_offset(0.0)
			emit_signal("pathCompleted")
	if !looping:
	#	var off = get_offset() #get offset on parent path
		var ccl = get_parent().get_curve().get_baked_length() #get the total length of parent path's curve
		if offset < target: #if this isnt the full length of the curve yet
			var mult = 0
			if speedCurve:
				mult = speedCurve.interpolate_baked(offset/ccl)
			var sp = walkSpeed * (1 + mult) * delta * dir #sp is the speed with which the offset is added. speed is modified based on a curve
			offset = clamp(offset + sp, min(0 - 1, target + 1), ccl)

			return unit_offset # returns false while path isnt complete	
		else: #if the follow has followed the whole path
			set_unit_offset(1) #set follow to exact end of path
			emit_signal("pathCompleted")
			return unit_offset #return true when path is complete

func walk_path_unit(delta):
	if unit_offset < 0.95: #if this isnt the full length of the curve yet
		var mult = 0
		if speedCurve:
			mult = speedCurve.interpolate_baked(unit_offset)
		var sp = walkSpeed * (1 + mult) * delta #sp is the speed with which the offset is added. speed is modified based on a curve
		unit_offset = (min(1.0, unit_offset + sp)) #set paths offset, if offset has become larger than total length, set it to total length	
		return false # returns false while path isnt complete	
	else: #if the follow has followed the whole path
		if looping:
			set_unit_offset(0.0)
			emit_signal("pathCompleted")
		else:
			set_unit_offset(1.0) #set follow to exact end of path
			emit_signal("pathCompleted")
			return true #return true when path is complete

func recalculate_target():
	target = get_parent().get_curve().get_baked_length()
