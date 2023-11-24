extends Area

var inRangeCounter
var resource

signal player_entered

func _on_IslandNode_start_initialize(save):
	resource = save.islandResource
	set_collision_shape_to_island_size()

func set_collision_shape_to_island_size():
	var height = (resource.islandCharacter.cellularHeight + 4) * resource.islandCharacter.scale
	var depth =  (resource.islandCharacter.cellularDepth + 4) * resource.islandCharacter.scale
	$CollisionShape.shape.extents = Vector3(depth,height,depth)


func _on_WholeIslandBox_body_entered(body):
	body.enter_island(resource)
	emit_signal("player_entered", body)
