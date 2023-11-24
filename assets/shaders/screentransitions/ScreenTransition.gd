extends TextureRect
class_name ScreenTransition

export(Array, Shader) var transitionShaders

var texRec = null
signal transition_started
signal transition_done

var transitioning = false

func _ready():
	texRec = TextureRect.new()
	get_tree().get_root().add_child(texRec)
	get_tree().get_root().move_child(texRec, 0)
	texRec.size = get_tree().get_root().get_viewport().size

func transition_start():
	rect_size = get_tree().get_root().get_viewport().size
	if transitioning == false:
		set_shader()
		transitioning = true
		get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
		yield(VisualServer, "frame_post_draw")
		var img = get_viewport().get_texture().get_data()
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		var tex = ImageTexture.new()
		img.flip_y()
		tex.create_from_image(img)
		set_texture(tex)
		emit_signal("transition_started")
		var tween = Tween.new()
		add_child(tween)
		tween.interpolate_property(material, 'shader_param/progress', 0.0, 1.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()
		yield(tween, "tween_completed")
		emit_signal("transition_done")
		transitioning = false
		queue_free()


func set_shader():
	material.shader = HelperScripts.random_value_from_array(transitionShaders)
	pass
