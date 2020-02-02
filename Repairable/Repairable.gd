extends Spatial
class_name Repairable

export(bool) var repaired := false
var repair_time : int

var num_times_repaired := 0
var num_repairs_needed := 10

func repair():
	num_times_repaired += 1
	if num_times_repaired >= num_repairs_needed:
		repaired = true
		repair_time = OS.get_ticks_msec()

func _process(delta):
	if repaired:
		var timeSinceRepair = OS.get_ticks_msec() - repair_time
		scale.y = 1 + 0.2 * sin(TAU * timeSinceRepair / 700)
