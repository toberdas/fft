extends SteeringAgent3D
class_name Moved

var moveList
const sizeRestriction = 4
var counter = 0

func _ready():
	moveList = []

func add_mover(moverInstance : MoverInstance):
	if moverInstance.time == null:
		moverInstance.time = moverInstance.moverResource.time
	var uniqueMoverResource = check_for_unique()
	var mover = moverInstance.moverResource
	if mover.unique:
		var oldprio = -1
		if uniqueMoverResource: oldprio = uniqueMoverResource.priority
		if mover.priority > oldprio: #with equal priority the old one stays
			clear_movers_rigorous()
			add(moverInstance)
		return 					#return cause there's a unique mover and your priority is too low
	
	if !uniqueMoverResource:
		if mover.clears:
			clear_movers()
		add(moverInstance)
		if moveList.size() > sizeRestriction:
			remove_oldest_mover()

func add(moverInstance : MoverInstance):
	if moverInstance is MoverInstance:
		moveList.append(moverInstance)
	else:
		print_debug("tried to add incorrect datatype to mover list")

func check_for_unique():
	for moverInstance in moveList:
		if mover_is_unique(moverInstance):
			return moverInstance.moverResource
	return null

func remove_oldest_mover():
	remove_mover(moveList[0])

func iterate_movers(delta): #method to loop through moverdict and execute the proper move function
	for moverInstance in moveList:
		var mover = moverInstance.moverResource
		var body = moverInstance.body
		if is_instance_valid(body): #check if node is still around
			if body.is_inside_tree():
				var f = Vector3.ZERO #force
				if mover.type == FishEnums.outcomes.seek: #if movers type is seek
					f = seek(body.global_transform.origin, mover.distance, mover.slowdown, mover.stop)
				if mover.type == FishEnums.outcomes.flee: #if movers type is flee
					f = flee(body.global_transform.origin, mover.distance)
				if mover.type == FishEnums.outcomes.flock: #if movers type is flock
					f += seek(body.global_transform.origin, mover.distance, mover.slowdown, mover.stop) 
					f += flee(body.global_transform.origin, mover.distance) 
					f += align_individual(body, mover.distance) * 1.2
					f /= 3.0
				if mover.type == FishEnums.outcomes.smartseek:
					f = smart_seek(body, mover.slowdown, mover.stop)
				var limitedFactor = max(0.0, mover.factor)
				add_force(f * limitedFactor) #multiply by movers factor
				moverInstance.tick_time(delta) #tick movers time
				if moverInstance.remove: #if their time was 0 on tick
					remove_mover(moverInstance) #remove the mover from the moverdict, making sure you dont move according to it anymore
		else: #if not remove it from moverdict
			remove_mover(moverInstance)

func mover_is_clearable(moverInstance : MoverInstance):
	return !mover_is_unique(moverInstance) && !mover_is_persistent(moverInstance)

func mover_is_unique(moverInstance : MoverInstance):
	return moverInstance.moverResource.unique

func mover_is_persistent(moverInstance : MoverInstance):
	return moverInstance.moverResource.persistent
	
func clear_movers():
	for moverInstance in moveList:
		if mover_is_clearable(moverInstance):
			remove_mover(moverInstance)

func clear_movers_rigorous():
	for moverInstance in moveList:
		if !mover_is_persistent(moverInstance):
			remove_mover(moverInstance)

func remove_mover(moverInstance:MoverInstance):
	moveList.erase(moverInstance)
