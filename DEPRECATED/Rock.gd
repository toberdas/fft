extends Node
class_name Rock

var position = Vector2.ZERO
var weight = 0.0
var pullforce = 0.0
var size = 0.0
var length = 0.0
var tiltAxis = Vector3.ZERO
var tiltAmount = 0.0
var rotateAmount = 0.0
var color = Color()
var transform = Transform.IDENTITY
var scalevec = Vector3.ZERO
var connectedRocks = []
var surface = null
var flockPoint = Vector3.ZERO

var directionDict = {
	"up" : {},
	"down" : {},
	"left" : {},
	"right" : {}
}

func _init(_position, character, seedPoint, first):
	position = _position
	run(character, seedPoint, first)

func run(character, seedPoint, first):
	make_rock_density(character.density, character.unity, first)
	make_pullforce(character.power, character.unity, first, seedPoint)
	make_rock_size(character.unity)
	make_rock_tilt(character.unity, character.power, seedPoint)
	make_rotate(character.unity, character.dynamic)
	make_trans(character)
	subdivide_surface(character)
	make_dir_dict()
#	character.physical.toInstance['cliffs'].append(self)

func make_rock_density(density = 0.5, unity = 0.5, first = false, noise = OpenSimplexNoise.new()):
	var nw = (noise.get_noise_2dv(position * 100) + 1.0) * 0.5
	var dw = density
	var rw = lerp(nw, dw, unity)
	weight = rw
	if first:
		density = 2.0
	
func make_pullforce(power = 0.5, unity = 0.5, first = false, seedPoint = Vector2(0.5,0.5)):
	var d = 1.0 - position.distance_to(seedPoint)
	d = pow(d, 4)
	var rd = randf()
	var pf = lerp(rd, d, unity)
	pullforce = pf * power
	if first:
		pullforce = 0.0

func make_rock_size(unity = 0.5):
	var rs = randf()
	var reals = lerp(rs, weight * 2.0, unity)
	size = reals

func make_rock_tilt(unity = 0.5, power = 0.5, seedPoint = Vector2(0.5,0.5)):
	var tax = Vector3(position.x,0.0,position.y).direction_to(Vector3(seedPoint.x,0.0,seedPoint.y)).cross(Vector3.UP).rotated(Vector3.UP, (1.0 - unity) * 2.0)
	tiltAxis = tax
	
	var d = min((position - seedPoint).length(), 1.0)
	var rd = randf() - 1.0
	var ta = lerp(rd, d, unity)
	tiltAmount = (ta - (1.0 - weight)) * (power * 2)

func make_rotate(unity = 0.5, dynamics = 0.5):
	rotateAmount = rand_range(-1.0,1.0) * (1.0 - unity) * dynamics

func make_trans(character):
	var scale = character.scale
	var height = character.height
	
	var rvec = (position - Vector2(0.5,0.5)) * (scale * 6)
	transform.origin.x = rvec.x
	transform.origin.z = rvec.y
	
	transform.basis = transform.basis.rotated(tiltAxis.normalized(), -tiltAmount * 0.1).orthonormalized()
	transform.basis = transform.basis.rotated(transform.basis.y, -rotateAmount * 2.0)
	
	scalevec = Vector3(1.0 + size * (scale * 0.75), scale + (scale * 1.5) * weight, 1.0 + size * (scale * 0.75))
	transform.basis.y *= scalevec.y
	transform.basis.x *= scalevec.x
	transform.basis.z *= scalevec.z
	
	var ap = pullforce - weight
	transform.origin.y = height + ap * (height * 0.5)
	transform.origin.y -= scalevec.y * 0.5
#	flockPoint = transform.origin
#	flockPoint.y += scalevec.y * 0.5
	
func subdivide_surface(character):
	surface = RockSurface.new(self, character)
	var i = 0 

func make_dir_dict():
	directionDict['up']['dir'] = -transform.basis.z
	directionDict['up']['surface'] = surface.surfaces[0]
	directionDict['down']['dir'] = transform.basis.z
	directionDict['down']['surface'] = surface.surfaces[-1]
	directionDict['left']['dir'] = -transform.basis.x
	directionDict['left']['surface'] = surface.surfaces[0]
	directionDict['right']['dir'] = transform.basis.x
	directionDict['right']['surface'] = surface.surfaces[-1]

func get_direction_surface(dir):
	var dot = -1.0
	var tkey = null
	for key in directionDict:
		var indic = directionDict[key]
		var ndot = indic['dir'].dot(dir)
		if ndot > dot:
			dot = ndot
			tkey = key
	var tindic = directionDict[tkey]
	return [tkey, tindic]
