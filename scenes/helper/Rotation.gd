#rotation node, 
extends Spatial

const TICKANGLE = 90
const MAXTIME = 0.5
const AVERAGEAMOUNT = 8

var active = false
var oat = 0
var at = 0
var moveInput = Vector2.ZERO
var timeBetween = 0
var averageAr = []
var average = 0
var help = Helper.new() #new helper class!
var mode = "average"
var direction = 0
signal tick

func _process(delta):
	if active: #only process when active
		moveInput.x = Input.get_joy_axis(0, 1)
		moveInput.y = Input.get_joy_axis(0, 0) #get input, will come from central input node in the future possibly
		moveInput = moveInput.normalized() #normalize it, not sure if needed now
		at = atan2(moveInput.y, moveInput.x)  # get the angle of the twee axes in radians
		at = rad2deg(at) #convert radians to degree
		if at: #dont do all this stuff if no input was given (atan(0,0) returns null)
			at = floor(int(at + 180) / TICKANGLE) #get div of our degrees + 180 (ranges from 0 to 360 now) with 90 or 45 call this our index
			if oat != at: #if the current index is different from in the previous step
				var d = oat - at #calculate the difference
				if direction == 0: #if theres no direction yet
					direction = sign(d) #set the direction to the sign of the difference, making it 1 or -1
				if d == direction: #if it's exactly 1, you made 1 step and are rotating properly
					tick(timeBetween) #so we call the tick function, suppyling the amount of time that has passed since the last tick function
			oat = at #store current index as old index
		timeBetween += delta #add up delta to timeBetween that keeps track of the amount of time that passes between ticks
		if timeBetween >= MAXTIME: #if time exceeds a certain limit
			tick(timeBetween) #also force a tick, to make it so that you dont get absurdly high time amounts

func tick(time):
	if mode == "average":
		help.limited_append(time,averageAr,AVERAGEAMOUNT) #add time to averageAr, limiting it to a certain size.
		average = help.get_average(averageAr) #get the average of averagear and set average to it, so other nodes can acces it.
		emit_signal("tick", average) #emit signal with average on it
	if mode == "absolute":
		emit_signal("tick", time)
	timeBetween = 0 #reset timeBetween

func reset():
	averageAr = []
	at = 0
	oat = 0
	timeBetween = 0

func start():
	active = true
	reset()

func stop():
	active = false
	reset()
