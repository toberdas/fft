extends Resource
class_name IslandVibeResource

var panoramaTexture
export(Array, StreamTexture) var panoramas

export(Color) var primaryColor = Color()
export(Color) var secondaryColor = Color()

var colorArray = []
var maxColors = 6

func _init(_character = IslandCharacter.new()):
	generate()

func generate():
	primaryColor = Color(randf(),randf(),randf(), 1.0)
	secondaryColor = Color(randf(),randf(),randf(), 1.0)
	panoramaTexture = HelperScripts.random_value_from_array(panoramas)

func add_color(color):
	if colorArray.size() < maxColors:
		colorArray.append(color)
	else:
		for color in colorArray:
			primaryColor = primaryColor.linear_interpolate(color, 1.0 / maxColors)
		colorArray = []
	pass
