extends Node

func _process(delta):
	var repairables = get_tree().get_nodes_in_group("Repairable")
	var num_repaired = 0
	for repairable in repairables:
		if repairable.repaired:
			num_repaired += 1
	
	var player = get_tree().get_nodes_in_group("Player")[0]
	var catcher = get_tree().get_nodes_in_group("Catcher")[0]

	$DebugLabel.text = (
		("Repaired: %s / %s\n" % [num_repaired, repairables.size()]) +
		("Repairer CDs: %s\n" % player.numCollected) +
		("Catches: %s\n" % catcher.num_caught)
	)
