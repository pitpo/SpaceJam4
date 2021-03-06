extends Node

enum CROWN {BOOMERANG, TELEPORTATION, JETPACK, SLOWDOWN}

var player
var game

var slow_down

var save

func _process(delta):
	if slow_down:
		slow_down -= delta
		if slow_down <= 0:
			slow_down = null

func reparent(node, new_parent):
	var old_pos = node.global_transform
	node.get_parent().remove_child(node)
	new_parent.add_child(node)
	node.global_transform = old_pos

func play_sample_at(source, stream):
	var sample = preload("res://Nodes/PointSample.tscn").instance()
	sample.translation = source.translation
	sample.stream = load(stream)
	source.get_parent().add_child(sample)

func time_scale():
	return 0.2 if slow_down else 1