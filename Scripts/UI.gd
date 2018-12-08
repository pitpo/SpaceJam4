extends CanvasLayer

var max_health = 5
var health = 5

func _process(delta):
	$Hearts.update()
	if health == 0:
		System.player.die()