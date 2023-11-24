extends Resource
class_name BrainState

export(String, "caught", "rest", "snap", "complex") var stateType
export(PackedScene) var stateExpressionScene

export(Resource) var fishResponse
export(Resource) var foodResponse
export(Resource) var unidentifiedResponse
export(Resource) var threatResponse
export(Resource) var relocateResponse

func get_fitting_response_to_situation(situation):
	match situation:
		"fish":
			return fishResponse
		"food":
			return foodResponse
		"unidentified":
			return unidentifiedResponse
		"threat":
			return threatResponse
		"relocate":
			return relocateResponse
	
