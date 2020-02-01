extends Node


var numCatches := 0
# We could also handle this via searching and calculating
export(int) var numRepaired := 0

func _process(delta):
	var repairables = get_tree().get_nodes_in_group("Repairable")
	numRepaired = 0
	for repairable in repairables:
		if repairable.repaired:
			numRepaired += 1
