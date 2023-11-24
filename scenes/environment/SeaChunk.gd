extends Spatial

var endlessSeaResource : EndlessSeaResource

func _on_FollowArea_area_entered(area):
	endlessSeaResource.followList.append(area)


func _on_FollowArea_area_exited(area):
	endlessSeaResource.followList.erase(area)


func _on_FollowArea_body_entered(body):
	endlessSeaResource.followList.append(body)


func _on_FollowArea_body_exited(body):
	endlessSeaResource.followList.erase(body)
