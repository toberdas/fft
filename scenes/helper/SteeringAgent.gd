extends Spatial
class_name SteeringAgent

const maxSpeed = 10.0
const maxForce = 1.0
const interpolateWeight = .2
const tickFrames = 2

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

func update_velocity():
	if forcetick > 0:
		velocity += acceleration / forcetick
		forcetick = 0
	else:
		velocity = Vector3.ZERO
	acceleration = Vector3.ZERO
	return velocity
	
#func _process(delta):
#	time += delta
#	if tick < tickFrames:
#		tick += 1
#	else:
#		tick = 0
#		if forcetick > 0:
#			targetVelocity += acceleration / forcetick
#			forcetick = 0
#		else:
#			targetVelocity = Vector3.ZERO #if no impulses agent must slow down to prevent infinite moving in one direction
#	acceleration = Vector3.ZERO
#	velocity = velocity.linear_interpolate(targetVelocity, interpolateWeight)
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

func seek(_target, slowdown = 12, stop = 2):
	var gto = global_transform.origin
	var desiredVelocity = _target - gto
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

func align_individual(target, dist):
	var alignvec = Vector3.ZERO
	if !target is Vector3:
		if (global_transform.origin - target.global_transform.origin).length() < dist:
			alignvec += target.velocity
	return alignvec

func wander():
	var rang = randf()
	var rvec = Vector3(cos(rang), sin(rang), rang)
	seek(global_transform.origin + velocity + rvec * maxSpeed, 4)

func flow(flowfield):
	var desiredVelocity = flowfield.sample_vec3(global_transform.origin)
	desiredVelocity *= maxSpeed
	var steer = desiredVelocity - velocity
	return steer

func flow_time(flowfield):
	var desiredVelocity = flowfield.sample_vec4(global_transform.origin, time)
	desiredVelocity *= maxSpeed
	var steer = desiredVelocity - velocity
	return steer
	
func align(node, dist):
	var alignvec = Vector3.ZERO
	if (global_transform.origin - node.global_transform.origin).length() < dist:
		if node != self:
			alignvec += node.velocity
	return alignvec


func limit(vector, limit):
	return vector.normalized() * limit

func get_velocity():
	return velocity
