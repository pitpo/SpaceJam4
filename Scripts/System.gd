extends Node

enum CROWN {BOOMERANG, SLOWDOWN, TELEPORTATION}

var player
var game

var slow_down = false

func reparent(node, new_parent):
	var old_pos = node.global_transform
	node.get_parent().remove_child(node)
	new_parent.add_child(node)
	node.global_transform = old_pos

func time_scale():
	return 0.2 if slow_down else 1