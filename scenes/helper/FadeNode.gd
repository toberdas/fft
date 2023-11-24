#children added to this node will fade in if they extend a canvas. 
#children freed from this node will fade out if they extend a canvas.

extends Node

var afterImage

func _on_FadeNode_child_entered_tree(node):
	if node is CanvasItem:
		var color = node.modulate
		color.a = 0.0
		node.modulate = color
		color.a = 1.0
		var tween = get_tree().create_tween()
		tween.tween_property(node, "modulate", color, 0.2)
	pass


func _on_FadeNode_child_exiting_tree(node):
	if node != $TextureRect:
		$TextureRect.visible = true
		$TextureRect.modulate = Color(1,1,1,1)
		get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
		var img = get_viewport().get_texture().get_data()
		var tex = ImageTexture.new()
		img.flip_y()
		tex.create_from_image(img)
		$TextureRect.set_texture(tex)
		var tween = get_tree().create_tween()
		tween.tween_property($TextureRect, "modulate", Color(1,1,1,0), 0.2)
	pass
	
func _exit_tree():
	$TextureRect.visible = false

func _enter_tree():
	$TextureRect.visible = false
