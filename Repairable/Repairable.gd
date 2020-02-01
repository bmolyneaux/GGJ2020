extends Spatial


export(bool) var repaired = false

func repair():
	repaired = true

func _process(delta):
	if repaired:
		scale.y = 1 + 0.2 * sin(TAU * OS.get_ticks_msec() / 1000)
