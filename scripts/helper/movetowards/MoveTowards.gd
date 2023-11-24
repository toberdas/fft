class_name MoveTowards
var objectA
var objectB
var transitionIncrement
var steps : float

func start(_objectA, _objectB, _steps):
	objectA = _objectA
	objectB = _objectB
	steps = _steps
	measure_difference()

func measure_difference():
	pass
