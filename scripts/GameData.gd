extends Node

var playerData = {
	"hookSpeed" : .6,
	"hookAcceleration" : .2,
	"hookDecceleration" : .1,
	"hookDrag" : .2,
	"hookLives" : 3
}

var rarityDict = {
	"everyday" : .8, 
	"strange" : .4, 
	"unique" : .1, 
	"artifact" : .05, 
	"stellar" : .01
}

var defaultPrimCol = Color(0.43, 0.93, 1.0, 1.0)
var defaultSecCol = Color(0.63, 0.93, 1.0, 1.0)

