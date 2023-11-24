extends Node
#
#var situationStandardDict = {
#	FishEnums.situations.fish : {
#		'mover' : FishEnums.outcomes.flock,
#		'state' : FishEnums.state.flowing,
#		'secondary' : FishEnums.secondaryOutcomes.song,
#		'unique' : false
#	},
#	FishEnums.situations.food : {
#		'mover' : FishEnums.outcomes.seek,
#		'state' : FishEnums.state.attacking,
#		'secondary' : FishEnums.secondaryOutcomes.dance,
#		'unique' : false
#	},
#	FishEnums.situations.unidentified : {
#		'mover' : FishEnums.outcomes.seek,
#		'state' : FishEnums.state.investigating,
#		'secondary' : FishEnums.secondaryOutcomes.dance,
#		'unique' : false
#	},
#	FishEnums.situations.threat : {
#		'mover' : FishEnums.outcomes.flee,
#		'state' : FishEnums.state.fleeing,
#		'secondary' : FishEnums.secondaryOutcomes.dance,
#		'unique' : true
#	}
#}

var situationStandardDict = { ##FULL AGGRO
	FishEnums.situations.fish : {
		'mover' : FishEnums.outcomes.seek,
		'state' : FishEnums.state.attacking,
		'secondary' : FishEnums.secondaryOutcomes.song,
		'unique' : true
	},
	FishEnums.situations.food : {
		'mover' : FishEnums.outcomes.seek,
		'state' : FishEnums.state.attacking,
		'secondary' : FishEnums.secondaryOutcomes.dance,
		'unique' : true
	},
	FishEnums.situations.unidentified : {
		'mover' : FishEnums.outcomes.seek,
		'state' : FishEnums.state.attacking,
		'secondary' : FishEnums.secondaryOutcomes.dance,
		'unique' : true
	},
	FishEnums.situations.threat : {
		'mover' : FishEnums.outcomes.seek,
		'state' : FishEnums.state.attacking,
		'secondary' : FishEnums.secondaryOutcomes.dance,
		'unique' : true
	}
}

var characterExceptionDict = {
	FishEnums.charactertags.assertive : {
		FishEnums.situations.unidentified : {
			'mover' : FishEnums.outcomes.seek,
			'state' : FishEnums.state.attacking,
			'secondary' : FishEnums.secondaryOutcomes.song,
			'unique' : true
		},
		FishEnums.situations.threat : {
			'mover' : FishEnums.outcomes.seek,
			'state' : FishEnums.state.attacking,
			'secondary' : FishEnums.secondaryOutcomes.song,
			'unique' : true
		}
	}
}

var outcomeAppraiseDict = {
	FishEnums.outcomes.seek : {
		'tags' : [FishEnums.charactertags.assertive],
		'states':[FishEnums.state.attacking, FishEnums.state.investigating],
		'secondary' : [FishEnums.secondaryOutcomes.song, FishEnums.secondaryOutcomes.dance, FishEnums.secondaryOutcomes.nothing],
		'factor' : [1.0],
		'unique' : true
	},
	FishEnums.outcomes.flee : {
		'tags' : [FishEnums.charactertags.apprehensive, FishEnums.charactertags.fishy, FishEnums.charactertags.ebuliant],
		'states': [FishEnums.state.fleeing],
		'secondary' : [FishEnums.secondaryOutcomes.song, FishEnums.secondaryOutcomes.dance, FishEnums.secondaryOutcomes.notetoself, FishEnums.secondaryOutcomes.nothing],
		'factor' : [2.0],
		'unique' : false
	},
	FishEnums.outcomes.flock : {
		'tags' : [FishEnums.charactertags.fishy, FishEnums.charactertags.cool],
		'states': [FishEnums.state.flowing],
		'secondary' : [FishEnums.secondaryOutcomes.song, FishEnums.secondaryOutcomes.dance, FishEnums.secondaryOutcomes.notetoself, FishEnums.secondaryOutcomes.nothing],
		'factor' : [.8],
		'unique' : false
	},
	FishEnums.outcomes.nothing : {
		'tags' : [FishEnums.charactertags.cool, FishEnums.charactertags.apprehensive],
		'states': [FishEnums.state.neutral],
		'secondary' : [FishEnums.secondaryOutcomes.song, FishEnums.secondaryOutcomes.dance, FishEnums.secondaryOutcomes.notetoself, FishEnums.secondaryOutcomes.nothing],
		'factor' : [0.0],
		'unique' : false
	}
}

var secondaryAppraiseDict = {
	FishEnums.secondaryOutcomes.song : {
		'tags' : [FishEnums.charactertags.ebuliant]
	},
	FishEnums.secondaryOutcomes.dance : {
		'tags' : [FishEnums.charactertags.assertive, FishEnums.charactertags.ebuliant]
	},
	FishEnums.secondaryOutcomes.notetoself : {
		'tags' : [FishEnums.charactertags.mute, FishEnums.charactertags.cool]
	},
	FishEnums.secondaryOutcomes.nothing : {
		'tags' : [FishEnums.charactertags.fishy, FishEnums.charactertags.mute]
	}
}

var brainstateAppraiseDict = {
	FishEnums.state.attacking : {
		'tags' : [FishEnums.charactertags.assertive]
	},
	FishEnums.state.eating : {
		'tags' : [FishEnums.charactertags.ebuliant]
	},
	FishEnums.state.fleeing : {
		'tags' : [FishEnums.charactertags.apprehensive, FishEnums.charactertags.fishy]
	},
	FishEnums.state.flowing : {
		'tags' : [FishEnums.charactertags.fishy, FishEnums.charactertags.cool]
	},
	FishEnums.state.investigating : {
		'tags' : [FishEnums.charactertags.ebuliant, FishEnums.charactertags.cool]
	},
	FishEnums.state.neutral : {
		'tags' : [FishEnums.charactertags.fishy, FishEnums.charactertags.mute]
	}
}
