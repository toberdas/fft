extends Node
class_name DFS

var markedVerts = []
var connections = []

var gridWidth = 0
var gridHeight = 0
var grid

var directions = [
	Vector2(1,0),
	Vector2(0,1),
	Vector2(-1,0),
	Vector2(0,-1)
]

var rng

func make_grid(w, h, initial_val):
	grid = HelperScripts.make_grid(w, h, initial_val)
	gridWidth = w
	gridHeight = h

func start_random_DFS_grid(_grid: Array = grid, startingvert: Vector2 = Vector2.ZERO):
	rng = RandomNumberGenerator.new()
	randomized_DFS_grid(startingvert)
#	print_debug(grid)

func randomized_DFS_grid(_vert):
	markedVerts.append(_vert)
	var newvert = get_new_unvisited_vert(_vert)
	while newvert:
		connect_verts(_vert, newvert)
		randomized_DFS_grid(newvert)
		newvert = get_new_unvisited_vert(_vert)

func get_new_unvisited_vert(_oldvert):
	var dirsdone = []
	var newvert
	while !newvert && dirsdone.size() < directions.size():
		var i = randi() % directions.size()
		if !dirsdone.has(i):
			dirsdone.append(i)
		newvert = get_new_vert(_oldvert, directions[i])
	return newvert
	
func get_new_vert(_vert, direction):
	var newvert = _vert + direction
	if check_if_visited(newvert):
		return false
	if newvert.x < 0 or newvert.x > gridWidth -1:
		return false
	if newvert.y < 0 or newvert.y > gridHeight -1:
		return false
	return newvert

func check_if_visited(_vert: Vector2):
	for vert in markedVerts:
		if _vert.is_equal_approx(vert):
			return true
	return false

func connect_verts(_vert, _newvert):
	connections.append([_vert, _newvert])
