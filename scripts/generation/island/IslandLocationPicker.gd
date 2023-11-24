extends Node
class_name IslandLocationPicker

func find_top_cells(ca): #finds top cells of a given cellular automaton
	var topcells = []
	for cell in ca.liveCells:
		if !ca.gridDict.has(cell.location + Vector3(0,1,0)): #if at ceiling
			topcells.append(cell)
		else:
			if ca.gridDict[cell.location + Vector3(0,1,0)].cellState == Cell.state.dead: #if the state of cell above is dead
				topcells.append(cell)
	return topcells

func find_surface_cells(ca : CellularAutomata3D):
	var surfcells = []
	for x in range(ca.myDepth):
		for z in range(ca.myDepth):
			for y in range(ca.myHeight - 1, 0, -1):
				var keyVec = Vector3(x,y,z)
				if ca.is_cell_alive(keyVec) or ca.is_cell_dying(keyVec):
					surfcells.append(ca.gridDict[keyVec])
					break
					
	return surfcells

func find_surface_cells_by_xy(ca : CellularAutomata3D):
	var surfcells = {}
	for x in range(ca.myDepth):
		for z in range(ca.myDepth):
			for y in range(ca.myHeight - 1, 0, -1):
				var keyVec = Vector3(x,y,z)
				if ca.is_cell_alive(keyVec) or ca.is_cell_dying(keyVec):
					surfcells[Vector2(x,z)] = ca.gridDict[keyVec]
					break
					
	return surfcells

func find_highest_cell(ca): #finds the highest cell of a given cellular automaton
	var hc = ca.liveCells[0]
	for cell in ca.liveCells:
		if cell.location.y > hc.location.y:
			hc = cell
	return hc

func find_lowest_cell(ca): #finds the lowest cell of a given cellular automaton
	var hc = ca.liveCells[0]
	for cell in ca.liveCells:
		if cell.location.y < hc.location.y:
			hc = cell
	return hc

func find_point_on_surface(surface): #finds a random point on the surface of given Surface
	if surface:
		var t = surface.transform
		var x = rand_range(-1.0, 1.0)
		var y = rand_range(-1.0, 1.0)
		var p = Vector3.ZERO
		p = t.origin + t.basis.y * 0.5
		p += t.basis.x * 0.5 * x
		p += t.basis.z * 0.5 * y
		return p
	return null

func find_bottom_cells(ca : CellularAutomata3D):
	var bottomcells = []
	for cell in ca.liveCells:
		var loc = cell.location + Vector3(0,1,0)
		if ca.gridDict.has(loc):
			if ca.gridDict[cell.location + Vector3(0,1,0)].check_pulse(): #if the state of cell above is alive
				bottomcells.append(cell)
	return bottomcells

func find_nearest_cell(point:Vector3,ca:CellularAutomata3D):
	var dist = 0.0
	var returnCell = null
	for cell in ca.liveCells:
		var newdist = (cell.location - point).length()
		if newdist > dist:
			dist = newdist
			returnCell = cell 
	return returnCell

func find_inside_cells(ca:CellularAutomata3D):
	var insidecells = []
	for x in range(ca.myDepth):
		for z in range(ca.myDepth):
			var topped = false
			var inside = false
			for y in range(ca.myHeight - 1, 0, -1):
				var keyVec = Vector3(x,y,z)
				if ca.is_cell_alive(keyVec) or ca.is_cell_dying(keyVec):
					if inside:
						insidecells.append(ca.gridDict[keyVec])
						inside = false
					topped = true
				if ca.is_cell_dead(keyVec):
					if topped:
						inside = true
	return insidecells
	pass

func inverse_normal_distribution():
	var d = Dice.new()
	d.add_die(6)
	d.add_die(6)
	d.add_die(6)
	var dx = (d.throw_all(true) -0.5) * 2.0
	var dy = (d.throw_all(true) -0.5) * 2.0
	var x = sign(dx) - dx
	var y = sign(dy) - dy
	return Vector2(x,y)


func find_base_cells(ca:CellularAutomata3D):
	var baseCells = []
	for x in range(ca.myDepth):
		for z in range(ca.myDepth):
			var keyVec = Vector3(x,1,z)
			if ca.is_cell_alive(keyVec) or ca.is_cell_dying(keyVec):
				baseCells.append(ca.gridDict[keyVec])
	return baseCells
