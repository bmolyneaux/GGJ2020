extends Node

var is_playing_second_song := false

func next_song():
	if is_playing_second_song:
		return
	is_playing_second_song = true
	
	$MixingDeskMusic.queue_bar_transition("Song2")
