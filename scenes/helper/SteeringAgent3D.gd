class_name SteeringAgent3D
extends KinematicBody

const maxSpeed = 1.0
const maxForce = 1.0
const interpolateWeight = .2
const tickFrames = 4

var target = Vector3.ZERO
var targetVelocity = Vector3.ZERO
var velocity = Vector3.ZERO setget ,get_velocity
var acceleration = Vector3.ZERO
var alignToVelocity = true
var tick = 0
var forcetick = 0
var targetTransform
var time = 0

var mass = .5

func _ready():
	pass 

func _process(delta):
	time += delta
	if tick < tickFrames:
		tick += 1
	else:
		tick = 0
		if forcetick > 0:
			targetVelocity += acceleration / forcetick
			forcetick = 0
		else:
			targetVelocity = Vector3.ZERO #if no impulses agent must slow down to prevent infinite moving in one direction
	acceleration = Vector3.ZERO
	velocity = velocity.linear_interpolate(targetVelocity, interpolateWeight)
	if velocity.length() > 0.1 && alignToVelocity: 
		targetTransform = transform.looking_at(transform.origin + velocity, Vector3.UP)
	else:
		targetTransform = transform
	if targetTransform:
		transform = transform.interpolate_with(targetTransform, 0.1)
	
func add_force(f): #adds a force to acceleration and a tick to forcetick, which the total acceleration is divided by when adding it to velocity
	forcetick += 1
	var l = f.length()
	if l > maxForce:
		f = f.normalized()
		f *= maxForce
	acceleration += f * (1 - mass)
	return acceleration

func seek(_target, distance = 12, slowdown = 12, stop = 2):
	var desiredVelocity = _target - global_transform.origin
	var l = desiredVelocity.length()
	desiredVelocity = desiredVelocity.normalized()
	if l < distance:
		if l < slowdown:
			if l < stop:
				desiredVelocity = Vector3.ZERO
			else:
				desiredVelocity *= maxSpeed * (l/slowdown)
		else:
			desiredVelocity *= maxSpeed
		var steer = desiredVelocity - velocity
		return steer
	else:
		return Vector3.ZERO

func smart_seek(_targetNode, slowdown = 12, stop = 2):
	var targetsVelocity = _targetNode.get('velocity')
	if targetsVelocity:
		var targetPosition = _targetNode.global_transform.origin
		var distanceRatio = (targetPosition - global_transform.origin).length() / (slowdown + 1)
		var _target = targetPosition + targetsVelocity * distanceRatio
		var desiredVelocity = _target - global_transform.origin
		var l = desiredVelocity.length()
		desiredVelocity = desiredVelocity.normalized()
		if l < slowdown:
			if l < stop:
				desiredVelocity = Vector3.ZERO
			else:
				desiredVelocity *= maxSpeed * (l/slowdown)
		else:
			desiredVelocity *= maxSpeed
		var steer = desiredVelocity - velocity
		return steer
	else:
		return seek(_targetNode.global_transform.origin, slowdown, stop)

func flee(from, dist):
	var desiredVelocity = global_transform.origin - from
	var l = desiredVelocity.length()
	if l < dist:
		desiredVelocity = desiredVelocity.normalized()
		desiredVelocity *= maxSpeed * (1 - l/dist)
		var steer = desiredVelocity - velocity
		return steer
	else:
		return Vector3.ZERO

func align_individual(node, dist):
	var alignvec = Vector3.ZERO
	
	if node.has_method("get_velocity"):
		if (global_transform.origin - node.global_transform.origin).length() < dist:
			alignvec += node.velocity
	return alignvec

func wander():
	var rang = randf()
	var rvec = Vector3(cos(rang), sin(rang), rang)
	seek(global_transform.origin + velocity + rvec * maxSpeed, 4)

func flow(flowfield):
	var desiredVelocity = flowfield.sample_vec3(global_transform.origin * 10.0)
	desiredVelocity *= maxSpeed
	var steer = desiredVelocity - velocity
	return steer

func flow_time(flowfield):
	var desiredVelocity = flowfield.sample_vec4(global_transform.origin * 10.0, time * 0.5)
	desiredVelocity *= maxSpeed
	var steer = desiredVelocity - velocity
	return steer

func flock(flock):
	var flockdata = flock.flockData
	var sep = seperate(flock.fishArray, flockdata.sepRange) * flockdata.sepFactor
	var align = align(flock.fishArray, flockdata.alignRange) * flockdata.alignFactor
	var cohe = cohesion(flock.fishArray, flockdata.coheRange, flockdata.slowdownRange) * flockdata.coheFactor
	add_force(sep)
	add_force(align)
	add_force(cohe)
	

func cohesion(flock, dist, slowdown):
	var cohvec = Vector3.ZERO
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
	var alignvec = Vector3.ZERO
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
	var sepvec = Vector3.ZERO
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
