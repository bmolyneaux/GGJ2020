extends Spatial

var collected = false

func collect():
	collected = true
	queue_free()
