extends Node

enum CROWN {BOOMERANG, SLOWDOWN, TELEPORTATION, JETPACK}

var player
var game

var slow_down = false

func reparent(node, new_parent):
	var old_pos = node.global_transform
	node.get_parent().remove_child(node)
	new_parent.add_child(node)
	node.global_transform = old_pos

func play_sample_at(source):
	var sample = preload("res://Nodes/PointSample.tscn").instance()
	sample.translation = source.translation
	source.get_parent().add_child(sample)

func time_scale():
	return 0.2 if slow_down else 1