extends Area

export(PackedScene) var crown

func _ready():
	$CrownBase.add_child(crown.instance())

func on_collect(body):
	if body == System.player:
		if System.player.crowns == 0: 
			System.player.get_node("Crown").visible = true
		System.player.crowns += 1
		queue_free()