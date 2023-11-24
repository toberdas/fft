extends Resource
class_name TagSet

var tagDict = {}
var amount = 3

func make_tagset_from_enum(enumm):
#	var tagAmount = enumm.size()
	var dominantTag = HelperScripts.random_key_from_dict(enumm)
	for key in enumm.keys():
		var localweight
		if key == dominantTag:
			localweight = 25
		else:
			localweight = 1 + randi() % 12
		var value = enumm[key]
		var newTag = Tag.new(value, key)
		newTag.weight = localweight
		tagDict[key] = newTag

func inherit_from_tagset(tagset, enumm = null):
	var foreignTagDict = tagset.tagDict
#	var tagAmount = foreignTagDict.size()
	for key in foreignTagDict.keys():
		var tag = foreignTagDict[key]
		if randf() > .3:
			var newTag = Tag.new(tag.tagValue, tag.readableTag)
			newTag.weight = tag.weight
			newTag.weight += int(max(1, (0.5 - randf()) * 2 * 6))
			tagDict[key] = newTag
		else:
			if enumm:
				random_tag_from_enum_to_dict(enumm)
				
func random_tag_from_enum_to_dict(enumm):
	var randomKey = HelperScripts.random_key_from_dict(enumm)
	var value = enumm[randomKey]
	var newTag = Tag.new(value, randomKey)
	newTag.weight = 1 + randi() % 12
	tagDict[randomKey] = newTag

func return_weight_of_tag(tag):
	if tagDict.has(tag):
		return tagDict[tag].weight
	return 0


static func check_array(tag, array):
	for _tag in array:
		if tag == _tag.tag:
			return _tag.weight
	return 0
