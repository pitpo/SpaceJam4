extends Node

enum CROWN {SLOWDOWN}

signal slowdown_switched

func crown_used(var crown):
	if crown == CROWN.SLOWDOWN:
		emit_signal("slowdown_switched")