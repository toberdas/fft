extends Node

enum presets{coral,pulsewave,spikygrowth,pyroclastic}

var presetArray = [
	{ #coral
	"stayAlive" : [5,6,7,8],
	"rebirth"   : [6,7,9,12],
	"states"    : 2,
	"neighbour" : Neighbourhood.style.Moore
	},
	{ #pulsewave
	"stayAlive" : [3],
	"rebirth"   : [1,2,3],
	"states"    : 10,
	"neighbour" : Neighbourhood.style.Moore
	},
#	{ #morestructures
#	"stayAlive" : [7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26],
#	"rebirth"   : [4],
#	"states"    : 4,
#	"neighbour" : Neighbourhood.style.Moore
#	},
	{ #spikygrowth
	"stayAlive" : [0,1,2,3,7,8,9,11,12,13,18,21,22,24,26],
	"rebirth"   : [13,17,20,21,22,23,24,25,26],
	"states"    : 4,
	"neighbour" : Neighbourhood.style.Moore
	},
	{ #pyroclastic
	"stayAlive" : [4,5,6,7],
	"rebirth"   : [6,7,8],
	"states"    : 10,
	"neighbour" : Neighbourhood.style.Moore
	},
]
