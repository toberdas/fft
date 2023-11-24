extends Spatial

var movers = {}
var steeringAgent = null

signal done_iterating

func _ready():
	steeringAgent = SteeringAgent.new()
	add_child(steeringAgent)

func _process(delta):
	iterate_movers(delta)

func iterate_movers(delta):
	var cumforce = Vector3.ZERO
	var flockforce = Vector3.ZERO
	var flockcount = 0
	for moverkey in movers.keys():
		var mover = movers[moverkey]
		var node = Vector3.ZERO
		if mover.node is Vector3:			#if node is a point
			node = mover.node
		if is_instance_valid(mover.node): #check if node is still around
			if mover.node.is_inside_tree():
				node = mover.node.global_transform.origin
		else: 							#if not remove it from moverdict
			movers.erase(moverkey)
		if mover.type == Mover.types.seek:
			cumforce += steeringAgent.seek(node)
		if mover.type == Mover.types.flee:
			cumforce += steeringAgent.flee(node, mover.distance)
		if mover.type == Mover.types.flock: 
			flockforce += (steeringAgent.flee(mover.node, mover.distance) + steeringAgent.seek(mover.node) + steeringAgent.align_individual(mover.node)) / 3.0 * mover.factor
			flockcount += 1
		steeringAgent.add_force(cumforce * mover.factor)
		mover.tick_time(delta) 	#tick movers time
		if mover.junked:		#if their time was 0 on tick
			movers.erase(moverkey)	#remove the mover from the moverdict, making sure you dont move according to it anymore
	steeringAgent.add_force(flockforce * (1 / (1 + flockcount)))
	var vel = steeringAgent.update_velocity()
	emit_signal("done_iterating", vel)
	print(vel)
	return vel

func add_mover(mover):
	var k = hash(mover.node) + hash(mover.type)
	if !movers.has(k):
		var uk = check_for_unique()
		if uk:
			if mover.unique:
				if mover.priority > movers[uk].priority: #with equal priority the oldest one stays
					movers.erase(uk)
					add(mover, k)
				return 					#return cause there's a unique mover and your priority is too low
		add(mover, k)

func add(mover, key):
	movers[key] = mover

func check_for_unique():
	if movers.size() == 1: 				#if there's 1 mover, it's unique
		var k = movers.keys()[0]
		if movers[k].unique:
			return k
	return false

func _on_FishBrainNode_mover_out(mover):
	add_mover(mover)
