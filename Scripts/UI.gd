extends CanvasLayer

var max_health = 5
var health = 5
var crowns = 0

func _process(delta):
	$Hearts.update()
	if health == 0:
		System.player.die()

func add_crown():
	crowns += 1
	$Crowns/Number.text = str(crowns)