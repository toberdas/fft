extends Spatial
class_name IslandNode

var islandResource
var islandSave

var active = false
var player = null
var point = null

var thread = null

signal start_initialize
signal start_deinitialize
signal loaded

func init(save):
	islandSave = save
	point = islandSave.point
	if islandSave.islandResource:
		islandResource = islandSave.islandResource
		start_init()
	else:
		generate_with_steps()
	rotate_x(rand_range(-0.05,0.05))
	rotate_y(rand_range(-0.05,0.05))
	rotate_z(rand_range(-0.05,0.05))

func generate_resource_threadless(save):
	TimePiece.targetTimeScale = 0.1
	yield(get_tree().create_timer(0.2),"timeout")
	islandResource = IslandResource.new()
	islandResource.generate()
	islandSave.islandResource = islandResource
	TimePiece.targetTimeScale = 1.0
	start_init()

func generate_with_steps():
	TimePiece.targetTimeScale = 0.1
	$IslandDataGeneratorNode.start_generating(islandSave)
	yield($IslandDataGeneratorNode,"resource_generated")
	islandResource = islandSave.islandResource
	TimePiece.targetTimeScale = 1.0
	start_init()
	
func thread_load(save): 
	thread = Thread.new()
	thread.start(self, "generate_resource", save)

func generate_resource(save):
	var ir = IslandResource.new()
	seed(save.islandSeed)
	ir.generate()
	call_deferred("_on_load_done", save);
	return ir

func _on_load_done(save):
	islandResource = thread.wait_to_finish()
	save.islandResource = islandResource
	start_init()

func start_init():
	GlobalSignals.emit_event("island_neared", [self])
	if !islandResource:
		islandSave = IslandSave.new()
		islandResource = IslandResource.new()
		islandSave.islandSeed = hash(GlobalTimer.time)
		islandSave.islandResource = islandResource
		islandResource.connect("resource_loaded", self, "emit_resources")
		islandResource.generate()
	else:
		emit_resources()
	islandSave.node = self
	$OffsetNode/IslandCellularNode.start_load(islandSave)
	emit_signal("loaded")

func emit_resources():
	emit_signal("start_initialize", islandSave)
	active = true

func _exit_tree():
	islandSave.node = null

#func _on_IslandFishNode_fish_loaded():
#	emit_signal("loaded")
