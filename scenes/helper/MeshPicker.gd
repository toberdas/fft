extends Node
class_name MeshPicker
tool

var dissolve = 0.0

export var myMesh = ""

var activeMesh = null

func _ready():
	set_vis_mesh(myMesh)

func _process(_delta):
	pass

func set_vis_mesh(meshname):
	for childmesh in get_children():
		if childmesh is MeshInstance:
			childmesh.set_visible(false)
			if childmesh.name == meshname:
				childmesh.set_visible(true)
				activeMesh = childmesh

