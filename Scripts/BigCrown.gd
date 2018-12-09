extends Area

export(PackedScene) var crown

func _ready():
	$CrownBase.add_child(crown.instance())

func on_collect(body):
	if body == System.player:
		System.player.crowns += 1
		System.player.get_node("Crown").visible = true
		queue_free()