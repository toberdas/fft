extends Resource
class_name Rule

export(String) var startSign = "A"
export(String, MULTILINE) var replacementString
export(String) var ruleSplit = "|"
export(String) var elementSplit = "~"
export(String) var tagSplit = "*"
export(String) var noSpaceChar = "`"

var replacementArray = []
var tagArray = []
var parsed = false

func parse_replacement_string():
	if !parsed:
		if replacementString:
			var reps = replacementString.rsplit(ruleSplit)
			for rep in reps:
				var tagsplit = Array(rep.rsplit(tagSplit))
				
				var elar = tagsplit.pop_back()
				var elsplit = elar.rsplit(elementSplit)
				elsplit = add_spaces_to_elements(elsplit)
				var dic = {
					'tags' : tagsplit,
					'elements' : elsplit
				}
				replacementArray.append(dic)
		parsed = true

func get_rule_out(tagset):
	var weightRoll = WeightedDistribution.new()
	for repDict in replacementArray:
		var weight = 1
		if tagset:
			for tag in repDict['tags']:
				weight += tagset.return_weight_of_tag(tag)
		weightRoll.add_option(repDict['elements'], weight)
	return weightRoll.roll()

func add_spaces_to_elements(elementArray):
	var ar = []
	for element in elementArray:
#		var newElement = element
		if element.begins_with(noSpaceChar) or element.begins_with("#") or element.begins_with("@"):
			if element.begins_with(noSpaceChar):
				element = element.trim_prefix(noSpaceChar)
		else:
			element = element.insert(0, " ")
		ar.append(element)
	return ar
