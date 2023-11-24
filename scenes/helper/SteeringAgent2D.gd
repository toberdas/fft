class_name SteeringAgent2D
extends KinematicBody2D

const maxSpeed = 2.0
const maxForce = 2.0
const interpolateWeight = 1
const tickFrames = 2

var target = Vector2.ZERO
var targetVelocity = Vector2.ZERO
var velocity = Vector2.ZERO setget ,get_velocity
var acceleration = Vector2.ZERO
var alignToVelocity = true
var tick = 0
var forcetick = 0
var targetTransform

var mass = .5

func _ready():
	pass 

func _process(_delta):
	if tick < tickFrames:
		tick += 1
	else:
		tick = 0
		if forcetick > 0:
			targetVelocity += acceleration / forcetick
			forcetick = 0
		else:
			targetVelocity = Vector2.ZERO #if no impulses agent must slow down to prevent infinite moving in one direction
	acceleration = Vector2.ZERO
	velocity = velocity.linear_interpolate(targetVelocity, interpolateWeight)
#	if velocity.length() > 0.001 && alignToVelocity: #cant ask for exact zero as we're working with veeeeeery small vectors for velocity here :(
#		targetTransform = transform.looking_at(transform.origin + velocity, Vector3.UP)
#	else:
#		targetTransform = transform
#	if targetTransform:
#		transform = transform.interpolate_with(targetTransform, 0.6)
	
func add_force(f): #adds a force to acceleration and a tick to forcetick, which the total acceleration is divided by when adding it to velocity
	forcetick += 1
	var l = f.length()
	if l > maxForce:
		f = f.normalized()
		f *= maxForce
	acceleration += f * (1 - mass)
	return acceleration

func seek(_target, slowdown):
	var desiredVelocity = _target - global_position
	var l = desiredVelocity.length()
	desiredVelocity = desiredVelocity.normalized()
	if l < slowdown:
		desiredVelocity *= maxSpeed * (l/slowdown)
	else:
		desiredVelocity *= maxSpeed

	var steer = desiredVelocity - velocity
	return steer

func flee(from, dist):
	var desiredVelocity = global_position - from
	var l = desiredVelocity.length()
	if l < dist:
		desiredVelocity = desiredVelocity.normalized()
		desiredVelocity *= maxSpeed * (1 - l/dist)
		var steer = desiredVelocity - velocity
		return steer
	else:
		return Vector2.ZERO
	
func wander():
	var rang = randf()
	var rvec = Vector2(cos(rang), sin(rang))
	seek(global_position + velocity + rvec * maxSpeed, 4)

func flow(flowfield):
	var desiredVelocity = flowfield.sample_vec2(global_transform.origin)
	desiredVelocity *= maxSpeed
	var steer = desiredVelocity - velocity
	return steer
	
func flow_time(flowfield, time):
	var desiredVelocity = flowfield.sample_vec3(Vector3(global_transform.origin.x, global_transform.origin.y, time))
	desiredVelocity = Vector2(desiredVelocity.x, desiredVelocity.y)
	desiredVelocity *= maxSpeed
	var steer = desiredVelocity - velocity
	return steer

func flock(flock, flockdata):
	var sep = seperate(flock, flockdata.sepRange) * flockdata.sepFactor
	var align = align(flock, flockdata.alignRange) * flockdata.alignFactor
	var cohe = cohesion(flock, flockdata.coheRange, flockdata.slowdownRange) * flockdata.coheFactor
	add_force(sep)
	add_force(align)
	add_force(cohe)

func cohesion(flock, dist, slowdown):
	var cohvec = Vector2.ZERO
	var fir = 0
	for bod in flock:
		if (global_transform.origin - bod.global_transform.origin).length() < dist:
			if bod != self:
				cohvec += seek(bod.global_transform.origin, slowdown)
				fir += 1
	if fir > 0:
		cohvec /= fir
	return cohvec
	
	
func align(flock, dist):
	var alignvec = Vector2.ZERO
	var fir = 0
	for bod in flock:
		if (global_transform.origin - bod.global_transform.origin).length() < dist:
			if bod != self:
				alignvec += bod.velocity
				fir += 1
	if fir > 0:
		alignvec /= fir
	return alignvec

func seperate(flock, dist):
	var sepvec = Vector2.ZERO
	var fir = 0
	for bod in flock:
		if (global_transform.origin - bod.global_transform.origin).length() < dist:
			if bod != self:
				sepvec += flee(bod.global_transform.origin, dist)
				fir += 1
	if fir > 0:
		sepvec /= fir
	return sepvec

func cheapflock(flocknode, flockdata):
	var sep = flee(flocknode.averagePos, flockdata.sepRange) * flockdata.sepFactor
	var align = flocknode.averageVel * flockdata.alignFactor
	var cohe = seek(flocknode.averagePos, flockdata.coheRange) * flockdata.coheFactor
	add_force(sep)
	add_force(align)
	add_force(cohe)

func limit(vector, limit):
	return vector.normalized() * limit

func get_velocity():
	return velocity


#extends KinematicBody2D
#class_name SteeringAgent2D
#
#var desiredVelocity = Vector2()
#var velocity = Vector2()
#var maxSpeed = 1
#var maxForce = 1
#var acceleration = Vector2()
#var mass = .2
#var speed = 1000
#
#func _ready():
#	pass 
#
#func _process(delta):
#	velocity += acceleration
#	move_and_slide(velocity.normalized() * delta * speed)
#	acceleration = Vector2(0,0)
#
#func add_force(f):
#	acceleration += f * (1 - mass)
#
#func seek(target, factor):
#	desiredVelocity = target - transform.origin
#	var l = desiredVelocity.length()
#	desiredVelocity = desiredVelocity.normalized()
#	if l < 10:
#		desiredVelocity *= 1 * (l/10)
#	else:
#		desiredVelocity *= maxSpeed
#	var steer = desiredVelocity - velocity
#	steer = steer.clamped(maxForce)
#	add_force(steer * factor)
#
#func flee(from, distance, factor):
#	var d = (from - transform.origin).length()
#	if d < distance:
#		desiredVelocity = transform.origin - from
#		var l = desiredVelocity.length()
#		desiredVelocity = desiredVelocity.normalized()
#		if l < 10:
#			desiredVelocity *= 1 * (l/10)
#		else:
#			desiredVelocity *= maxSpeed
#		var steer = desiredVelocity - velocity
#		steer = steer.clamped(maxForce)
#		add_force(steer * factor)
#	pass
#
#func flow(flowfield):
#	var desiredVelocity = flowfield.sample_vec2(global_transform.origin)
#	desiredVelocity *= maxSpeed
#	var steer = desiredVelocity - velocity
#	return steer
#
#func flow_time(flowfield, time):
#	var desiredVelocity = flowfield.sample_vec3(Vector3(global_transform.origin.x, global_transform.origin.y, time))
#	desiredVelocity = Vector2(desiredVelocity.x, desiredVelocity.y)
#	desiredVelocity *= maxSpeed
#	var steer = desiredVelocity - velocity
#	return steer
#
#func limit(vector, limit):
#	return vector.normalized() * limit
