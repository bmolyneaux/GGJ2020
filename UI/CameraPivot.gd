extends Spatial

export(int) var index

func _process(delta):
	var player
	var players = get_tree().get_nodes_in_group("player")
	for p in players:
		if p.index == index:
			player = p
	
	translation = player.translation
