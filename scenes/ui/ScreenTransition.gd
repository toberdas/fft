extends Node
class_name ScreenTransition

onready var transitionShaders = [preload("res://assets/shaders/screentransitions/screentransition_colordist.tres"), preload("res://assets/shaders/screentransitions/screentransition_perlin.tres"), preload("res://assets/shaders/screentransitions/screentransition_simpelzoom.tres"), preload("res://assets/shaders/screentransitions/screentransition_swirl.gdshader"), preload("res://assets/shaders/screentransitions/screentransition_waterdrop.tres"), preload("res://assets/shaders/screentransitions/screentransition_windowslice.tres")]

var texRec = null
signal transition_started
signal transition_done

var transitioning = false

func _init():
	pass

#func _ready():
#	texRec = TextureRect.new()
#	get_tree().get_root().add_child(texRec)
#	get_tree().get_root().move_child(texRec, 0)
#	texRec.rect_size = get_tree().get_root().get_viewport().size

func transition_start():
	texRec = TextureRect.new()
	texRec.mouse_filter = Control.MOUSE_FILTER_PASS
	get_tree().get_root().add_child(texRec)
#	get_tree().get_root().move_child(texRec, 0)
	texRec.rect_size = get_tree().get_root().get_viewport().size
	if transitioning == false:
	
		transitioning = true
		get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
		yield(VisualServer, "frame_post_draw")
		var img = get_viewport().get_texture().get_data()
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		var tex = ImageTexture.new()
		img.flip_y()
		tex.create_from_image(img)
		texRec.set_texture(tex)
		set_shader()
		emit_signal("transition_started")
		var tween = Tween.new()
		add_child(tween)
		tween.interpolate_property(texRec.material, 'shader_param/progress', 0.0, 1.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()
		yield(tween, "tween_completed")
		emit_signal("transition_done")
		transitioning = false
		texRec.queue_free()
		queue_free()


func set_shader():
	var newshadmat = ShaderMaterial.new()
	texRec.material = newshadmat
	newshadmat.shader = HelperScripts.random_value_from_array(transitionShaders)

