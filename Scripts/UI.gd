extends CanvasLayer

var max_health = 5
var health = 5
var crowns = 0

func _process(delta):
	$Hearts.update()
	
	if health <= 0:
		System.player.die()
	
	if System.slow_down:
		$IceEffect.visible = true
		$IceEffect/TimeLeft.value = System.slow_down * 100
	else:
		$IceEffect.visible = false

func add_crown():
	crowns += 1
	$Crowns/Number.text = str(crowns)

func damage():
	System.player.get_node("Attack").play()
	health -= 1