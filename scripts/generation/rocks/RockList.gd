extends Resource
class_name RockList

enum fillTypes{square, cross, line}

var rockList = []
var topRockList = []
var walkList = []

func _init(depth, height, amount = 4, filltype = randi() % fillTypes.size()):
	fill_rock_list(depth, height, amount, filltype)

func fill_rock_list(depth, height, amount, filltype):
	var d = Dice.new()
	d.add_die(depth)
	
	var i = 0
	var er = 0
	while i < amount && er < 1000:
		var newR = Vector3(d.throw_all(false), 0, d.throw_all(false))
		if check_rock(newR):
			var h = 3 + int((float(i)/float(amount) * height))
			var stepList = RandomWalk.new().walk_in_bounds(h, depth, depth)
			if filltype == fillTypes.cross:
				fill_cross(h, newR, stepList)
			if filltype == fillTypes.square:
				fill_square(h, newR, stepList)
			if filltype == fillTypes.line: ##Deactivated
#				fill_square(h, newR, stepList)
				fill_line(h, newR, stepList)
			i += 1
		er += 1

func check_rock(r):
	if rockList.has(r):
		return false
	for rock in rockList:
		if (rock - r).length() < 2:
			return false
	return true

func fill_line(h, newR, stepList):
	for x in range(3):
		for m in range(h):
			var newX = -1 + x + newR.x + stepList[m].x
			var newZ = newR.z + stepList[m].y
#			var newloc = Vector3(-1 + x + newR.x,m,newR.z)
			var newloc = Vector3(newX,m,newZ)
			if !rockList.has(newloc):
				rockList.append(newloc)
				if m == h:
					topRockList.append(newloc)

func fill_square(h, newR, stepList):
	for m in range(h):
		for x in range(3):
			for z in range(3):
				var newX = newR.x + stepList[m].x - 1 + x
				var newZ = newR.z + stepList[m].y -1 + z
#				var newloc = Vector3(newR.x - 1 + x, m, newR.z - 1 + z)
				var newloc = Vector3(newX, m, newZ)
				if !rockList.has(newloc):
					rockList.append(newloc)
					if m == h:
						topRockList.append(newloc)
				
func fill_cross(h, newR, stepList):
	for m in range(h):
		var newX = newR.x + stepList[m].x
		var newZ = newR.z + stepList[m].y
		rockList.append(Vector3(newX - 1, m, newZ))
		rockList.append(Vector3(newX + 1, m, newZ))
		rockList.append(Vector3(newX, m, newZ - 1))
		rockList.append(Vector3(newX, m, newZ + 1))
		rockList.append(Vector3(newX, m, newZ))
		if m == h:
			topRockList.append(Vector3(newX - 1, m, newZ))
			topRockList.append(Vector3(newX + 1, m, newZ))
			topRockList.append(Vector3(newX, m, newZ - 1))
			topRockList.append(Vector3(newX, m, newZ + 1))
			topRockList.append(Vector3(newX, m, newZ))
#		rockList.append(Vector3(newR.x - 1, m, newR.z))
#		rockList.append(Vector3(newR.x + 1, m, newR.z))
#		rockList.append(Vector3(newR.x, m, newR.z - 1))
#		rockList.append(Vector3(newR.x, m, newR.z + 1))
#		rockList.append(Vector3(newR.x, m, newR.z))
#		if m == h:
#			topRockList.append(Vector3(newR.x - 1, m, newR.z))
#			topRockList.append(Vector3(newR.x + 1, m, newR.z))
#			topRockList.append(Vector3(newR.x, m, newR.z - 1))
#			topRockList.append(Vector3(newR.x, m, newR.z + 1))
#			topRockList.append(Vector3(newR.x, m, newR.z))
