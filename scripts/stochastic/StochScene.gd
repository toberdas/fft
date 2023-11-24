extends Spatial

var scaley = null
var motif = null
var motifCol = null
var ncutoff = .5
var ca
#TESTING

func _ready():
	randomize()
	startup()

func _process(delta):
	if Input.is_action_just_pressed("action"):
		test()
	if Input.is_action_just_pressed("jump"):
		update()
	if Input.is_action_just_pressed("ui_focus_next"):
		modulate()
	if Input.is_action_just_pressed("ui_up"):
		new_scale()

func startup():
	$IslandNodeTest.run()
	
func test():
	$IslandNodeTest.run()
	
func ca():
	ca.generation()
	$Spatial.clear()
	$Spatial.add_platforms_from_cells(ca.liveCells, 64)
	
func sca():
	var depth = 64
	var height = 12
	ca = CellularAutomata3D.new(depth, height)
	var rm = RockList.new(depth, height, 6)
	ca.fill_from_array(rm.rockList)
	
func update():
	pass

func modulate():
	pass

func new_scale():
	pass

