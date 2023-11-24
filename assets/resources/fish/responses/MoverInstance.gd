extends Resource
class_name MoverInstance

var moverResource
var time
var body
var remove

func tick_time(delta): #tick time function, if remove is true, this mover will be removed from the moverdict
	if time != -1: #time on -1 means no ticking, or infinite follow
		if time > 0:
			time -= delta
		else:
			remove = true

func initialize_with_resource_and_body(_moverResource, _body):
	moverResource = _moverResource
	body = _body
	time = moverResource.time
	
