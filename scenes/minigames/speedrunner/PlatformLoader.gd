extends Node2D

var loadedArray = [] #array containing a column of loaded cells per x

export(PackedScene) var platformScene

var width = 0
var height = 0
var scalee = 0

var offset = 0

func load_column(width):
	var columnArray = []
	for i in range(height):
		if check_at_position(width, i):
			var loadedPlatform = load_platform_at_position(width, i)
			columnArray.append(loadedPlatform)
	return columnArray

func unload_column(index):
	var platformPopArray = loadedArray.pop_at(index)
	for platform in platformPopArray:
		platform.queue_free()
		
func load_initial_screen():
	for x in range(width):
		loadedArray.append(load_column(x))

func check_at_position(x, y):
	return $NoiseLocationFinder.check_location(x, y)

func load_platform_at_position(x, y):
	var np = platformScene.instance()
	np.position = Vector2((-width * scalee * 0.5) + (x * scalee), y * scalee)
	add_child(np)
	return np

func _on_PlatformGenerator_initialize(data):
	width = data.width
	height = data.height
	scalee = data.screenScale
	load_initial_screen()

func _on_LoadTracker_load_movement(loadMovement):
	if loadMovement != 0:
		offset += loadMovement
		if loadMovement > 0:
			move_right()
		if loadMovement < 0:
			move_left()
			

func move_right():
	loadedArray.append(load_column(width - 1 + offset))
	unload_column(0)

func move_left():
	loadedArray.push_front(load_column(offset))
	unload_column(-1)
