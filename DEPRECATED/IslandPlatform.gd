extends Node
class_name IslandPlatform

var transform = Transform()

func _init(character, pos, dir = null, basis = Basis()):
	transform.basis = basis
	transform.origin = pos
	if dir:
		transform = transform.looking_at(pos + dir, Vector3.UP)
	transform.basis.z *= 5 + randf() * 3
	transform.basis.x *= 3 + randf() * 3
	transform.basis.y *= transform.origin.y
	transform.origin -= transform.basis.y * 0.5
	transform.origin += randf() * transform.basis.x * 2.0
	character.physical.toInstance['platforms'].append(self)
