extends MiniGame

var difficulty

var grid
var dfs
#var walls = []

export(int) var width = 12
export(int) var height = 12
export(float) var mazeScale = 64.0
export(float) var pathThickness = 12.0
export(float) var timeToFind = 120.0
export(NodePath) var targetFish
export(NodePath) var player
export(NodePath) var timer

func _ready():
	if targetFish:
		targetFish = get_node(targetFish)
	if player:
		player = get_node(player)
	if timer:
		timer = get_node(timer)
		timer.set_wait_time(timeToFind)
		timer.connect("timeout", self, "too_slow")
		timer.start()
		
	randomize()
	dfs = DFS.new()
	dfs.make_grid(width,height,0)
	dfs.start_random_DFS_grid()
	grid = dfs.grid
	make_maze(dfs.connections, mazeScale, pathThickness)

func make_maze(_connections, _scale, _linethickness):
	var integconnect = get_integral_connections(_connections)
	targetFish.position = place_target(integconnect) * mazeScale #gets a random path ending and scale it up by mazescale to get a position for the targetfish
	targetFish.get_node("Area2D").connect("body_entered", self, "fish_found")
	
	var wallgrid = HelperScripts.make_grid(width + 1,height + 1,0) #creates a grid with width by height dimensions
	var walls = make_walls(wallgrid) #this algorithm returns two grid duplicates of the original wall-grid. one for the horizontal walls and one for the vertical.
	var dwalls = demolish_walls(_connections, walls) #this algorithm goes through the path connections, and sets every wall that intersects the path to 0
	var xconnectarray = HelperScripts.remove_from_array(HelperScripts.grid_to_array(dwalls[0]),0) #for both hor and vert walls, remove all 0s and make an array from the grid
	var yconnectarray = HelperScripts.remove_from_array(HelperScripts.grid_to_array(dwalls[1]),0)
	xconnectarray = get_integral_connections(xconnectarray) #get an array of arrays of connections that line up for both horizontal and vertical walls
	yconnectarray = get_integral_connections(yconnectarray)
	var xpolygons = lines_to_polygons(xconnectarray, _scale, _linethickness)
	var ypolygons = lines_to_polygons(yconnectarray, _scale, _linethickness)
	var xbod = polygons_to_statbod(xpolygons)
	var ybod = polygons_to_statbod(ypolygons)
	make_occluders(xpolygons)
	make_occluders(ypolygons)

	xbod.position -= Vector2.ONE * mazeScale / 2 #shift the walls so they nicely envelop the path
	ybod.position -= Vector2.ONE * mazeScale / 2
	
func make_walls(_grid):
	var xwalls = _grid.duplicate(true)
	var ywalls = _grid.duplicate(true)
	for i in _grid.size():
		for j in _grid[i].size():
			if i < _grid.size() - 1:
				xwalls[i][j] = [Vector2(i,j), Vector2(i + 1,j)] #wall along the x axis
			if j < _grid.size() - 1:
				ywalls[i][j] = [Vector2(i,j), Vector2(i,j +1)]  #wall along the y axis
	return [xwalls, ywalls]

func demolish_walls(_connections, walls):
	var _walls = walls
	for connection in _connections:
		var dir = connection[1] - connection[0] #get the direction between connections points
		var dirx = max(0, dir.x) #dirx and diry are either 0 or 1, used to shift over 1 index in the wallgrid, as the wallgrid is 1 longer than the pathgrid
		var diry = max(0, dir.y)
		var xind = dirx + connection[0].x
		var yind = diry + connection[0].y
		
		_walls[max(0,abs(dir.x))][xind][yind] = 0
	return _walls

func lines_to_polygons(_connections, _scale, _thickness):
	var linear = make_lines(_connections, _scale)
	var colpolyar = thicken_lines(linear, _thickness)
	return colpolyar

func polygons_to_statbod(polygons):
	var statbod = StaticBody2D.new()
	add_child(statbod)
	for poly in polygons:
		var col = CollisionPolygon2D.new()
		col.polygon = poly
		statbod.add_child(col)
	return statbod

func make_lines(integrals, _scale):
	var linear = []
	for integral in integrals:
		if integral is Array:
			var line = Line2D.new()
			var linepointar = []
			for connection in integral:
				if connection is Array:
					linepointar.append(connection[0] * _scale)
					linepointar.append(connection[1] * _scale)
			line.points = PoolVector2Array(linepointar)
			linear.append(line)
	return linear

func get_integral_connections(_connections):
	var connectionar = []
	var currentar = []
	var lastconnection = [Vector2.ZERO, Vector2.ZERO]
	for connection in _connections:
		if lastconnection[1] != connection[0]:
			connectionar.append(currentar)
			currentar = []
		currentar.append(connection)
		lastconnection = connection
	connectionar.append(currentar)
	return connectionar

func thicken_lines(linear, _linethickness):
	var polyar = []
	for line in linear:
		var line_poly = Geometry.offset_polyline_2d(line.points, _linethickness)
		polyar.append(line_poly[0])
	return polyar

func make_occluders(polygons):
	for polygon in polygons:
		var occl = LightOccluder2D.new()
		var occlpol = OccluderPolygon2D.new()
		occlpol.polygon = polygon
		occl.occluder = occlpol
		add_child(occl)
		occl.transform.scaled(Vector2(0.8,0.8))
		occl.position -= Vector2.ONE * mazeScale / 2

func place_target(integrals):
	var rn = randi() % integrals.size()
	var loc 
	loc = integrals[rn][-1][1]
	return loc

func fish_found(_body):
	yield(targetFish.get_node("Area2D"), "body_entered") #stupid fucking hack for a stupid fucking bug
	if _body == player:
		fish_hit(1000)

func too_slow():
	fish_miss(1000)
