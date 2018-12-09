extends Area

func on_enter(body):
	if body == System.player:
		queue_free()
		System.game.ui.add_crown()