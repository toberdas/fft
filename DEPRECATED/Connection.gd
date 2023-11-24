extends Node
class_name Connection

var startKey = Vector2.ZERO
var startRock = null
var startPoint = null
var targetKey = Vector2.ZERO
var targetRock = null
var targetPoint = null
var path = null

func try(rockdict, ownkey, desperate = false):
	for c in range(10):
		for key in rockdict.keys():
			if key != ownkey:
				var dist = (ownkey - key).length()
				if dist < c * 0.1:
					if rockdict[key].connectedRocks.find(ownkey) == -1:
						if rockdict[key].connectedRocks.size() == 0 or desperate:
							
							startKey = ownkey
							startRock = rockdict[ownkey]
							startRock.connectedRocks.append(key)
							targetKey = key
							targetRock = rockdict[key]
							targetRock.connectedRocks.append(ownkey)
							return targetKey
	return false

func run(character):
	create_points(startRock, targetRock)
	var sto = startPoint.transform.origin
	var tpo = targetPoint.transform.origin
	var pointar = [sto, tpo]
	if abs(tpo.y - sto.y) > 3:        
		var latchpoint = tpo
		latchpoint.y = sto.y
		pointar = [sto, latchpoint, tpo]
	path = PlatformPath.new(character, self, pointar)
	
func create_points(startrock, targetrock):
	var tdir = (startrock.transform.origin - targetrock.transform.origin).normalized()
	var sdir = (targetrock.transform.origin - startrock.transform.origin).normalized()
	startPoint = set_point(startrock, sdir)
	targetPoint = set_point(targetRock, tdir)
	startPoint.targetPoint = targetPoint
	targetPoint.targetPoint = startPoint

func set_point(rock, dir):
	var ar = rock.get_direction_surface(dir)
	var p = ar[1]['surface'].get_edge_point(ar[0])
	return p
