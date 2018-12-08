extends CanvasLayer

var max_health = 5
var health = 5

func _process(delta):
	$Hearts.update()
	if health == 0:
		get_tree().change_scene("res://Scenes/GameOver.tscn")