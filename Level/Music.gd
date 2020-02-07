extends Node

func next_song():
	if $Song2.playing:
		return
	
	$Song1.stop()
	$Song2.play()
