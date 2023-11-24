extends Node
class_name Point

var transform = Transform.IDENTITY
var parent = null
var targetPoint = null
var paths = []
var connection = null
var direction = null

func _init(_parent, location, _dir):
	direction = _dir
	parent = _parent
	make_trans(parent, location)

func make_trans(parent, location):
	transform.basis = Basis(parent.transform.basis.get_rotation_quat())
	transform.origin = location
	
