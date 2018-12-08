extends Node

enum CROWN {SLOWDOWN}

signal slowdown_switched

var player

func crown_used(var crown):
	if crown == CROWN.SLOWDOWN:
		emit_signal("slowdown_switched")