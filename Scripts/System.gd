extends Node

enum CROWN {BOOMERANG, SLOWDOWN, TELEPORTATION}

signal slowdown_switched

var player
var game

func reparent(node, new_parent):
	var old_pos = node.global_transform
	node.get_parent().remove_child(node)
	new_parent.add_child(node)
	node.global_transform = old_pos