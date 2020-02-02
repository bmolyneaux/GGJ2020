extends Node

var game_won = false
var winner = ''

func _process(delta):
	var repairables = get_tree().get_nodes_in_group("Repairable")
	var num_repaired = 0
	for repairable in repairables:
		if repairable.repaired:
			num_repaired += 1

	var player := get_tree().get_nodes_in_group("player")[0] as Repairer
	var catcher = get_tree().get_nodes_in_group("Catcher")[0]

	if not game_won:
		if catcher.num_caught >= 3:
			game_won = true
			winner = "Dog"
		if num_repaired >= repairables.size():
			game_won = true
			winner = "Cat"
	
	var debugText := ""
	debugText += "Repaired: %s / %s\n" % [num_repaired, repairables.size()]
	debugText += "Repairer CDs: %s\n" % player.num_collected
	debugText += "Catches: %s\n" % catcher.num_caught
	if game_won:
		debugText += winner + " wins!\n"
	$DebugLabel.text = debugText
