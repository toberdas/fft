extends Resource
class_name Neighbourhood

enum style{Moore, Neumann}

var checkList = []

const axes = [Vector3(1,0,0), Vector3(0,1,0), Vector3(0,0,1)]

func _init(_style):
	if _style == style.Moore:
		new_moore()
	if _style == style.Neumann:
		new_neumann()

func new_moore():
	for x in range(3):
		for y in range(3):
			for z in range(3):
				checkList.append(Vector3(-1 + x, -1 + y, -1 + z))

func new_neumann():
	checkList.append(Vector3(1, 0, 0))
	checkList.append(Vector3(-1, 0, 0))
	checkList.append(Vector3(0, 1, 0))
	checkList.append(Vector3(0, -1, 0))
	checkList.append(Vector3(0, 0, 1))
	checkList.append(Vector3(0, 0, -1))
