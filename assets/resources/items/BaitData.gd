extends Resource
class_name BaitResource

export(Array, String, "salt", "sweet", "bitter", "sour", "tangy", "umami") var taste
export(Array, String, "crunchy", "squishy", "tender", "watery", "slimy", "crispy", "sludgy", "sticky") var texture

export(Resource) var cookedItem

export(float) var subtlety
export(float) var smellStrength = .5
