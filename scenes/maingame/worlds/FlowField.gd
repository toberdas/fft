extends Node
class_name FlowField

var noise

func setup():
	noise = OpenSimplexNoise.new() as OpenSimplexNoise

	# Configure
	noise.seed = randi()
	noise.octaves = 2
	noise.period = 256.0
	noise.persistence = 1
	noise.lacunarity = 2.0

func _init():
	setup()

func _ready():
	setup()

func sample_vec3(from):
	var v = noise.get_noise_3dv(from)
	return Vector3(cos(rad2deg(v)), sin(rad2deg(v)), v)

func sample_vec2(from):
	var v = noise.get_noise_2dv(from)
	return Vector2(cos(rad2deg(v)), sin(rad2deg(v)))

func sample_vec4(from, time):
	var v = noise.get_noise_4d(from.x, from.y, from.z, time)
	return Vector3(cos(rad2deg(v)), sin(rad2deg(v)), v)
