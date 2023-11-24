extends Control


func set_colors(color : Color):
	set_rect_shader_gradient_color($TextureRect, color)
	set_rect_shader_gradient_color($TextureRect2, color)
	set_rect_shader_gradient_color($Background, color)
	$ColorRect.color = color
	
func set_rect_shader_gradient_color(rectchild : TextureRect, color : Color):
	var gradtext = GradientTexture.new()
	gradtext.gradient = Gradient.new()
	gradtext.gradient.set_color(0, color.darkened(0.6))
	gradtext.gradient.set_color(1, color.darkened(0.9))
	rectchild.material.set_shader_param("palette", gradtext)



