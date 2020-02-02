extends Node

var game_won = false
var winner = ''

var last_catcher_score := 0
var last_player_score := 0

func _process(delta):
	var repairables = get_tree().get_nodes_in_group("Repairable")
	var num_repaired := 0
	for repairable in repairables:
		if repairable.repaired:
			num_repaired += 1

	var player := get_tree().get_nodes_in_group("player")[0] as Repairer
	var catcher = get_tree().get_nodes_in_group("Catcher")[0]

	var player_score := num_repaired
	var catcher_score = catcher.num_caught
	
	if player_score == last_player_score and catcher_score == last_catcher_score:
		return
	
	if not game_won:
		if catcher.num_caught >= 3:
			game_won = true
			winner = "Dog"
			if has_node("WinnerText"):
				$WinnerText.text = "Dog Wins"
		if num_repaired >= repairables.size():
			game_won = true
			winner = "Cat"
			if has_node("WinnerText"):
				$WinnerText.text = "Cats Win"
	if game_won:
		$BoomBoxes.visible = false
		$Cats.visible = false

	if player_score != last_player_score and player_score <= $BoomBoxes.get_child_count():
		$BoomBoxes.get_children()[player_score - 1].activate()
	if catcher_score != last_catcher_score and catcher_score <= $Cats.get_child_count():
		$Cats.get_children()[catcher_score - 1].activate()
	
	var debugText := ""
	debugText += "Repaired: %s / %s\n" % [num_repaired, repairables.size()]
	debugText += "Repairer CDs: %s\n" % player.num_collected
	debugText += "Catches: %s\n" % catcher.num_caught
	if game_won:
		debugText += winner + " wins!\n"
	$DebugLabel.text = debugText
	
	last_player_score = player_score
	last_catcher_score = catcher_score

func _restart():
	get_tree().reload_current_scene()

func _maybe_restart():
	if game_won:
		_restart()

func _unhandled_input(event):
	if not event.is_pressed():
		return
	if event is InputEventKey:
		var key := event as InputEventKey
		if key.scancode == KEY_R:
			_restart()
		if key.scancode == KEY_ENTER:
			_maybe_restart()
	if event is InputEventJoypadButton:
		var button := event as InputEventJoypadButton
		if button.button_index == JOY_START:
			_maybe_restart()
