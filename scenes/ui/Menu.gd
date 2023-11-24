extends Node
class_name Menu

export(bool) var add_children_as_instances = true

var instances = {}
var open = false

var currentInstanceKey = ""

signal menu_opened
signal menu_closed

export(Array, PackedScene) var loadInstances

func _ready():
	if loadInstances.size() > 0:
		for instance in loadInstances:
			add_instance_from_scene_with_name(instance, instance.name)
			instance.modulate = Color(1,1,1,0)
	if add_children_as_instances:
		if get_child_count() > 0:
			for child in get_children():
				remove_child(child)
				add_instance_with_name(child, child.name)
				child.modulate = Color(1,1,1,0)

func switch_instance_open(toInstanceKey):
	if open:
		var oldInstance = get_current_instance()
		remove_instance_child(oldInstance)
		var newInstance = instances[toInstanceKey]
		currentInstanceKey = toInstanceKey
		add_instance_as_child(newInstance)

func switch_instance_closed(toInstanceKey):
	currentInstanceKey = toInstanceKey
	
func open_instance(toInstanceKey):
	switch_instance_closed(toInstanceKey)
	open_menu()

func add_instance_from_scene_with_name(scene, _name):
	var instance = scene.instance()
	add_instance_with_name(instance, _name)
	return instance

func add_instance_with_name(instance, _name):
	set_current_key_if_empty(_name)
	instances[_name] = instance

func remove_instance_by_name(_name):
	instances[_name].queue_free()
	instances.erase(_name)

func set_current_key_if_empty(_name):
	if instances.empty():
		currentInstanceKey = _name

func close_menu():
	if open:
		var currentInstance = get_current_instance()
		remove_instance_child_hard(currentInstance)
		open = false
		emit_signal("menu_closed")

func open_menu():
	if !open:
		var currentInstance = get_current_instance()
		add_instance_as_child(currentInstance)
		open = true
		emit_signal("menu_opened")

func add_instance_as_child(instance):
	if !is_currently_opened(instance):
		add_child(instance)
		if instance.has_method("added_to_menu"):
			instance.added_to_menu()
	var tween = get_tree().create_tween()
	tween.tween_property(instance, "modulate", Color(1,1,1,1), 0.2)

func remove_instance_child(instance):
	var tween = get_tree().create_tween()
	tween.tween_property(instance, "modulate", Color(1,1,1,0), 0.2)
	yield(tween,"finished")
	if !is_currently_opened(instance):
		remove_child(instance)
		if instance.has_method("closed_in_menu"):
			instance.closed_in_menu()

func remove_instance_child_hard(instance):
	var tween = get_tree().create_tween()
	tween.tween_property(instance, "modulate", Color(1,1,1,0), 0.2)
	yield(tween,"finished")
	remove_child(instance)
	if instance.has_method("closed_in_menu"):
		instance.closed_in_menu()

func is_currently_opened(instance):
	return instance == get_current_instance() && instance.get_parent() == self

func get_current_instance():
	return instances[currentInstanceKey]

func toggle_menu():
	if open:
		close_menu()
		return
	if !open:
		open_menu()

func cycle_key(direction):
	var keys = instances.keys()
	var keyIndex = keys.find(currentInstanceKey)
	if keyIndex != -1:
		var newKeyIndex = wrapi(keyIndex + direction, 0, keys.size())
		switch_instance_open(keys[newKeyIndex])
		currentInstanceKey = keys[newKeyIndex]
		
func set_instance_property(key, property, value, path = null):
	if path:
		var base = instances[key]
		var node = base.get_node(path)
		node.set(property, value)
	else:
		instances[key].set(property, value)
		
func get_instance_property(key, property, path = null):
	if path:
		var base = instances[key]
		var node = base.get_node(path)
		return node.get(property)
	else:
		return instances[key].get(property)
