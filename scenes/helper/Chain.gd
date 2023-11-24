extends Spatial
class_name Chain

var linkScene = preload("res://scenes/helper/Link.tscn")
var links = [] setget ,get_links_pos
var anchor
var ind = 0
var target = 0
var making = false
var index = 0
var posArray = []

signal chain_done

func _exit_tree(): #when casting is removed, and chain is being removed, make sure to also remove the pieces of chain attached to other nodes!
	clear_chain()

func _process(_delta):
	if making:
		add_link()

func add_link():
	var newlink = linkScene.instance()
	links.append(newlink)
	if index == 0:
		add_child(newlink) #first link has to be secured to player as child
	else:
		get_tree().get_root().add_child(newlink) #add links to root, otherwise they wont move (weird bug) also makes them move independently from player
	newlink.global_transform.origin = posArray[index]
	if index > 0:
		links[index - 1].get_node("Joint").set_node_b(newlink.get_path())
	newlink.set_mode(1)
	index += 1
	if index > posArray.size()-1:
		making = false
		links[0].set_mode(0)
		links[0].get_node("Joint").set_flag_x(1, false)
		links[0].get_node("Joint").set_flag_y(1, false)
		links[0].get_node("Joint").set_flag_z(1, false)
		anchor = linkScene.instance()
		get_tree().get_root().add_child(anchor) #anchor also to root node so it doesnt move with the player
		anchor.global_transform.origin = links.back().global_transform.origin + Vector3(1,1,1)
		anchor.set_mode(1)
		links.back().get_node("Joint").set_node_b(anchor.get_path())
		index = 0
		emit_signal("chain_done")
		

func cut_chain(flt):
	var _index = int(links.size() * flt)
	var destroyLinks = links.slice(_index+2,-1)
	links = links.slice(0, _index + 1)
	for link in destroyLinks:
		link.queue_free()
	

func make_chain_on_array(array):
	posArray = array.duplicate()
	making = true

func clear_chain():
	for link in links:
		link.queue_free()
	links = []
	if anchor:
		anchor.queue_free()
		anchor = null

func freeze_switch(onoff):
	if onoff == false:
		for i in range(1, links.size()):
			links[i].set_mode(0)
	if onoff == true:
		for i in range(1, links.size()):
			links[i].set_mode(1)

func unfreeze_partial(fract : float):
	var linkAmount = links.size()
	var unfreezeAmount = int(float(linkAmount * fract))
	for i in range(1, unfreezeAmount):
		if links[i].get_mode() != 0:
			links[i].set_mode(0)

func get_links_pos():
	if links.size() > 0:
		var posAr = []
		for i in range(0, links.size()):
			posAr.append(links[i].global_transform.origin)
		return posAr
	else:
		return null

func path_to_links(path):
	var posar = get_links_pos()
	var curvepoints = path.get_curve().get_point_count()
	if posar:
		for i in range(min(posar.size(), curvepoints)):
			path.get_curve().set_point_position(i, to_local(posar[i]))

func curve_from_chain():
	var curve = Curve3D.new()
	var posar = get_links_pos()
	if posar:
		for pos in posar:
			curve.add_point(pos)
	return curve

func fasten_to_anchor(node):
	links.back().global_transform.origin = node.global_transform.origin
	node.get_parent().remove_child(node)
	links.back().add_child(node)
	node.global_transform.origin = links.back().global_transform.origin

func anchor_to_node(node):
	HelperScripts.switch_parent_keep_transform(links.back(), node)

func loosen_anchor():
	links.back().set_mode(0)
	anchor.set_mode(0)
