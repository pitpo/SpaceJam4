extends CanvasLayer

var max_health = 5
var health = 5
var crowns = 0
var next_music

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

func change_music(stream):
	System.save = [System.player.translation, crowns, System.player.crowns]
	next_music = load(stream)
	$"../Music/AnimationPlayer".play("FadeOut")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeOut":
		$"../Music/AnimationPlayer".play("FadeIn")
		$"../Music".stream = next_music
		$"../Music".play()