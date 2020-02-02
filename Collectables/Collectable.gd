extends Spatial
class_name Collectable

var collected = false

func collect():
	collected = true
	queue_free()
