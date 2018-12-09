extends Area

func on_enter(body):
	if body == System.player:
		System.game.ui.add_crown()
		System.play_sample_at(self, "res://Berys/Muzyka/Don_t Stop/pick_crown_small.wav")
		queue_free()