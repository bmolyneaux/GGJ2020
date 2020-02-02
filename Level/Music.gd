extends Node

var song = "Song"

var tracks = [
	"Drums",
	"Snare",
	"Synth"
]

var tracks_playing := 0

func add_track():
	if tracks_playing >= len(tracks):
		return
	
	$MixingDeskMusic.fade_in(song, tracks[tracks_playing])
	tracks_playing += 1

func _ready():
	$MixingDeskMusic.start_alone(song, tracks[tracks_playing])
	tracks_playing = 1
	yield(get_tree().create_timer(2.0), "timeout")
	add_track()
	yield(get_tree().create_timer(2.0), "timeout")
	add_track()
	yield(get_tree().create_timer(2.0), "timeout")
	add_track()
