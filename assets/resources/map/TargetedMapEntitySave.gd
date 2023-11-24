extends MovingMapEntitySave
class_name TargetedMapEntitySave


export(Resource) var targetSave 


func get_new_target_point(map):
	if targetSave:
		map.leave_entity(targetSave)
	targetSave = map.get_closest_entity(HelperScripts.random_vec2(), IslandSave)	
	return targetSave.point


