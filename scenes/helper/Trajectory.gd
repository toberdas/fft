extends Spatial

var predictHit = false
var collision = null
var lineArray = []
var curve = Curve3D.new() #curve is used to make a evenly distributed array of points, from a probe that moves faster and faster depending on increment used
var maxDraw = 32

onready var probe = $Probe
onready var line = $TrajectoryLine

export var gravity = .02

#func update_trajectory(increment, probespeed, stepmax):
#	collision = null
#	predictHit =  false #set hit variables to false everytime before going through step-loop
#	lineArray = [] #reset linearray, used for drawing
#	probe.reset(increment, probespeed) #reset the probe, increment, is used to make the probe go faster, making the trajectory longer
#	lineArray.append(probe.global_transform.origin) #start with probe starting position
#	for _i in range(stepmax): #and let probe step maxtry amount of times in a loop
#		if predictHit == false: #if the probe hasnt hit a body
#			probe.step(gravity, 0.95) #step the probe, supplying the amount of gravity working on the probe ((want to chagne this to style in the future, to make different moving probes))
#			lineArray.append(probe.global_transform.origin) #append the new probe position
#			line.points = lineArray.slice(0, maxDraw) #give new array to draw slicing as much as maxDraw allows
##			line.points = lineArray
#		else: #if the probe did hit a body
#			return {"collision" : collision, "linearray" : lineArray} #return the body, and deprecated second argument
#	return {"collision" : collision, "linearray" : lineArray} 

func update_trajectory(increment, probespeed, stepmax):
	collision = null
	predictHit =  false #set hit variables to false everytime before going through step-loop
	lineArray = [] #reset linearray, used for drawing
	probe.reset(increment, probespeed) #reset the probe, increment, is used to make the probe go faster, making the trajectory longer
	lineArray.append(probe.global_transform.origin) #start with probe starting position
	for _i in range(stepmax): #and let probe step maxtry amount of times in a loop
#		if predictHit == false: #if the probe hasnt hit a body
		probe.step(gravity, 0.95) #step the probe, supplying the amount of gravity working on the probe ((want to chagne this to style in the future, to make different moving probes))
		lineArray.append(probe.global_transform.origin) #append the new probe position
		line.points = lineArray.slice(0, maxDraw) #give new array to draw slicing as much as maxDraw allows
#			line.points = lineArray
#		else: #if the probe did hit a body
#			return {"collision" : collision, "linearray" : lineArray} #return the body, and deprecated second argument
	return {"collision" : collision, "linearray" : lineArray} 

func _on_Probe_predicthit(body): #called when probe hits a body
	collision = body #track which body was hit
	predictHit = true #set predictHit to true to break out of step-loop
