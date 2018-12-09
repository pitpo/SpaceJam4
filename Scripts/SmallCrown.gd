extends Area

func on_enter(body):
	if body == System.player:
		System.game.ui.add_crown()
		System.play_sample_at(self)
		queue_free()