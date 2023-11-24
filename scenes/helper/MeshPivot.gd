extends Spatial

var targetTransform = Transform()
export(NodePath) var targetZNode
export(float, -1, 1) var maxNormal = .5
export var interpolateFloat = 3.0
var quat = Quat()

func _ready():
	if targetZNode:
		targetZNode = get_node(targetZNode)

func align_to_normal():
	var z 
	var n
	var nz
	var nn
	var nx
	if targetZNode:
		z = targetZNode.global_transform.basis.z
	else:
		z = global_transform.basis.z
	
	if $RayCast.is_colliding():
		nn = $RayCast.get_collision_normal()
	else:
		nn = Vector3.UP
	if nn.dot(Vector3.UP) > maxNormal:
		n = nn
	else:
		n = Vector3.UP
	nx = n.cross(z).normalized()
	nz = nx.cross(n).normalized()
	
	targetTransform.basis.z = nz
	targetTransform.basis.y = n
	targetTransform.basis.x = nx
	pass

func _process(delta):
	align_to_normal()
	quat = quat.slerp(targetTransform.basis.get_rotation_quat(), interpolateFloat * delta)
	global_transform.basis = Basis(quat)
	#transform = transform.interpolate_with(targetTransform, interpolateFloat * delta)
