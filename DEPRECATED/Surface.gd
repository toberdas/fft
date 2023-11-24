extends Node
class_name Surface

var transform = Transform()
var scale = 0.02
var walk = null

var directionDict = {
	"up" : {},
	"down" : {},
	"left" : {},
	"right" : {}
}

#func _init(posar, rocktrans, surfnum, character):
#	var mvec = rocktrans.basis.y * 0.5
#	mvec -= rocktrans.basis.x * 0.5
#	mvec -= rocktrans.basis.z * 0.5
#	transform.basis = Basis(rocktrans.basis.get_rotation_quat())
#	var sc = rocktrans.basis.get_scale()
#	mvec += (posar[0].x + posar[1].x * 0.5) * rocktrans.basis.x 
#	mvec += (posar[0].y + posar[1].y * 0.5) * rocktrans.basis.z
#	mvec += posar[2] * rocktrans.basis.y  * scale * 0.5
#	transform.basis.x *= posar[1].x * sc.x
#	transform.basis.z *= posar[1].y * sc.z
#	transform.basis.y *= posar[2] * sc.y * scale
#	transform.origin = rocktrans.origin + mvec
#	character.physical.toInstance['surfaces'].append(self)
#	populate_with_doodads(character)

func _init(posar, rocktrans, surfnum, character):
	var mvec = rocktrans.basis.y * 0.5
	mvec -= rocktrans.basis.x * 0.5
	mvec -= rocktrans.basis.z * 0.5
	transform.basis = Basis(rocktrans.basis.get_rotation_quat())
	var sc = rocktrans.basis.get_scale()
	mvec += (posar[0].x + posar[1].x * 0.5) * rocktrans.basis.x
	mvec += (posar[0].y + posar[1].y * 0.5) * rocktrans.basis.z
	mvec.y += rocktrans.origin.y - 36 + posar[2] * 6
	mvec.x += randf() * 5
	mvec.z += randf() * 5
	transform.basis.x *= posar[1].x * sc.x
	transform.basis.z *= posar[1].y * sc.z
	transform.basis.y *= sc.y
	transform.origin = rocktrans.origin + mvec
	
	character.physical.toInstance['surfaces'].append(self)
#	populate_with_doodads(character)
	make_dir_dict()

#func populate_with_doodads(character):
#	var d = Dice.new()
#	var it = int((transform.basis.x.length() + transform.basis.z.length()) * 0.05)
#	d.add_die(6)
#	d.add_die(6)
#	d.add_die(6)
#	for _i in range(it):
#		var dx = (d.throw_all(true) -0.5) * 2.0
#		var dy = (d.throw_all(true) -0.5) * 2.0
#		var x = sign(dx) - dx
#		var y = sign(dy) - dy
#		var do = Doodad.new(transform, Vector2(x,y), character)
#	pass

func make_dir_dict():
	directionDict['up']['dir'] = -transform.basis.z
	directionDict['down']['dir'] = transform.basis.z
	directionDict['left']['dir'] = -transform.basis.x
	directionDict['right']['dir'] = transform.basis.x

func get_edge_point(dir):
	var d = directionDict[dir]['dir']
	return Point.new(self, transform.origin + (d * 0.5) + (transform.basis.y * 0.5), dir)
