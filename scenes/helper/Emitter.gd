extends Spatial
class_name Emitter

var graceTimer = 0

export var interval = 2.0
export var minRadius = .2
export var maxRadius = 8.0
export var emitSpeed = .6

export var emitState = "off" #"off" means inactive, "out" means its expanding outward, "grace" means its waiting to flip to out again
var radius = minRadius

func _process(delta):
	if emitState == "out": #only if the emitstate is "out" will bobber emit
		emit(maxRadius, emitSpeed)
	if emitState == "grace": #in gracestate count down till emitting again
		graceTimer += 1 * delta
		if graceTimer >= interval:
			switch_state("out")
			graceTimer = 0
	
func switch_state(target):
	if target == "off":
		$CollisionShape.get_shape().radius = 0
	emitState = target
	

func emit(target, speed):
	radius = move_toward(radius, target, speed) #move towards maxradius with speed
	if radius >= maxRadius - speed: #if maxradius (- speed??) is reached, set radius back to 0, set state to off, so it doesnt emit anymore, set a timer to switch back to "out" after set interval
		radius = minRadius
		switch_state("grace")
	$CollisionShape.get_shape().radius = radius #set actual collisionShapes radius to our radius value
