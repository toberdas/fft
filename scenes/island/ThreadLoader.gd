extends Node
class_name ThreadLoader

var thread

signal load_done

func _ready():
	thread = Thread.new()

func load_scene(path, type):
	var err = thread.start(self, "_thread_load", ResourceLoader.load_interactive(path))
	if !err == 0:
		emit_signal("load_done", false)

func _thread_load(interactive_ldr):
	while (true):
		var err = interactive_ldr.poll();
		if(err == ERR_FILE_EOF):
			call_deferred("_on_load_done");
			return interactive_ldr.get_resource();

func _on_load_done():
	var resource = thread.wait_to_finish()
	emit_signal("load_done", resource)

func load_resource(path, type = null):
	load_scene(path, type)
