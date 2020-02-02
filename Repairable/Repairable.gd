extends Spatial
class_name Repairable

export(bool) var repaired := false
var repairTime : int

func repair():
	repaired = true
	repairTime = OS.get_ticks_msec()

func _process(delta):
	if repaired:
		var timeSinceRepair = OS.get_ticks_msec() - repairTime
		scale.y = 1 + 0.2 * sin(TAU * timeSinceRepair / 700)
