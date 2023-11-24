extends Sprite

var time = 0.0
export(Resource) var skyResource

func _process(delta):
	self.material.set("shader_param/SUNCOLOR",skyResource.sunColor)
	self.material.set("shader_param/SKYCOLORBRIGHTEST",skyResource.skyLightColor)
	self.material.set("shader_param/SKYCOLORDARKEST",skyResource.skyDarkColor)
	self.material.set("shader_param/ABSORPTION",skyResource.absorption)
	self.material.set("shader_param/THICKNESS",skyResource.thickness)
	self.material.set("shader_param/COVERAGE",skyResource.coverage)
	self.time -= delta * skyResource.cloudSpeedModifier
	self.material.set("shader_param/iTime",self.time)
	self.material.set("shader_param/iFrame",self.time)
