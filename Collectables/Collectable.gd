extends Spatial
class_name Collectable

var collected := false
var spawnCounter := 0.0
var spawnCountLength := 3.0

func be_dropped():
	spawnCounter = spawnCountLength

func _process(delta):
	if spawnCounter > 0:
		spawnCounter -= delta
		if spawnCounter < 0:
			spawnCounter = 0

func can_collect():
	return not collected and spawnCounter <= 0

func collect():
	collected = true
	queue_free()
