extends Spatial

export(NodePath) var IKTarget
export(NodePath) var FishTailPoint
export(NodePath) var FishMesh
export(NodePath) var IKPivot

var sod = null

var sodx
var sody
var sodz

var sodw

var rot = Vector3()
var targetrotp = Vector3()
export var f = 2.0
export var z = 1.0
export var r = 0.0

var targetBase = Basis()

var maxdist = .5


func _ready():
	set_as_toplevel(true)
	FishMesh = get_node(FishMesh)
	IKTarget = get_node(IKTarget)
#	FishTailPoint = get_node(FishTailPoint)
	IKPivot = get_node(IKPivot)
	$FishBone/Armature/Skeleton/SkeletonIK.start(false)

	sod = SecondOrderDynamics.new(f, z, r, FishMesh.global_transform.basis.get_euler())
	var q = FishMesh.transform.basis.get_rotation_quat()
	sodx = SecondOrderDynamicsFloat.new(f, z, r, q.x)
	sody = SecondOrderDynamicsFloat.new(f, z, r, q.y)
	sodz = SecondOrderDynamicsFloat.new(f, z, r, q.z)
	sodw = SecondOrderDynamicsFloat.new(f, z, r, q.w)

#func _process(delta):
#	var targetrot = FishMesh.global_transform.basis.get_euler()
#	rot = IKPivot.global_transform.basis.get_euler()
#	var ydif =   (min(targetrot.y, targetrotp.y) - max(targetrot.y, targetrotp.y))
#	var xdif =   (min(targetrot.x, targetrotp.x) - max(targetrot.x, targetrotp.x))
#	var zdif =   (min(targetrot.z, targetrotp.z) - max(targetrot.z, targetrotp.z))
#	if abs(xdif) >= PI or abs(ydif) >= PI or abs(zdif) >= PI:
#		rot *= -1.0
##		sod.yd = rot
##		sod.xp = rot
#		sod.y = rot
##		rot = sod.update(delta, targetrot)
#	else:
#		rot = sod.update(delta, targetrot)
#	targetrotp = targetrot
#	var basis = Basis(rot)
#
#	IKPivot.global_transform.basis = basis
#	IKTarget.transform.basis = basis

#func _process(delta):
#	IKPivot.transform.basis.x = sodx.update(delta, FishMesh.global_transform.basis.x).normalized()
#	IKPivot.transform.basis.y = sody.update(delta, FishMesh.global_transform.basis.y).normalized()
#	IKPivot.transform.basis.z = sodz.update(delta, FishMesh.global_transform.basis.z).normalized()
#	IKPivot.transform = IKPivot.transform.orthonormalized()

#func _process(delta):
#	var quat = IKPivot.transform.basis.get_rotation_quat()
#	var q = FishMesh.transform.basis.get_rotation_quat()
#	if quat.dot(q) <= 0.0:
#		q.x *= -1.0152
#		q.y *= -1.0
#		q.z *= -1.0
#		q.w *= -1.0
#
#	quat.x = sodx.update(delta, q.x, 1.0)
#	quat.y = sody.update(delta, q.y, 1.0)
#	quat.z = sodz.update(delta, q.z, 1.0)
#	quat.w = sodw.update(delta, q.w, 1.0)
#	quat = quat.normalized()
#	var up = quat * Vector3.UP
#	var right = quat * Vector3.RIGHT
#	var forward = quat * Vector3.FORWARD
#	targetBase = Basis(right, up, -forward)
#	IKPivot.transform.basis = IKPivot.transform.basis.slerp(targetBase, 0.5)

func _process(delta):
	var quat = IKPivot.transform.basis.get_rotation_quat()
	var q = FishMesh.transform.basis.get_rotation_quat()
	quat.x = sodx.update(delta, q.x, 1.0)
	quat.y = sody.update(delta, q.y, 1.0)
	quat.z = sodz.update(delta, q.z, 1.0)
	quat.w = sodw.update(delta, q.w, 1.0)
	quat = quat.normalized()
	var up = quat * Vector3.UP
	var right = quat * Vector3.RIGHT
	var forward = quat * Vector3.FORWARD
	targetBase = Basis(right, up, -forward)
	IKPivot.transform.basis = IKPivot.transform.basis.slerp(targetBase, delta * 10.0)


#func _process(delta):
#	var tq = FishMesh.global_transform.basis.get_rotation_quat()
#	var wvec = Vector3(tq.w, 0, 0)
#	var neww = sodw.update(delta, wvec)
#	print(neww)
#	neww.x = fposmod(neww.x, 1.0)
#	tq.w = neww.x
#	IKPivot.global_transform.basis = Basis(tq)
#	IKPivot.global_transform.basis.get_rotation_quat().w = neww.x

func _on_InputScene_input_out(moveInput):
	$FishBone.rotate(FishMesh.transform.basis.y.normalized(), moveInput.x * 0.1)
	$FishBone.rotate(FishMesh.transform.basis.x.normalized(), moveInput.y * 0.1)


func _on_Fish_transform_out(_global_transform):
	$FishBone.global_transform = _global_transform
	global_transform.origin = _global_transform.origin
