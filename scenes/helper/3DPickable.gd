extends Spatial
class_name ThreeDPickable

signal picked

var active = true

func picked(_pickingPointer):
	if active:
		emit_signal("picked", _pickingPointer)	
