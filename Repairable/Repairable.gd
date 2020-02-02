extends Spatial
class_name Repairable

export(bool) var repaired := false
var repair_time : int

var num_times_repaired := 0
var num_repairs_needed := 10

func _ready():
	$Sprite3D.texture = $Viewport.get_texture()
	_updateText()

func repair():
	num_times_repaired += 1
	if num_times_repaired >= num_repairs_needed:
		repaired = true
		repair_time = OS.get_ticks_msec()
		$Radio.start_animation()
		$FixSfx.play()
	$InsertSfx.play()
	_updateText()

func _updateText():
	if repaired:
		$Sprite3D.visible = false
		
	var repairs_left := num_repairs_needed - num_times_repaired
	var repair_string := "%s" % repairs_left
	repair_string = repair_string.replace("0", "O")
	$Viewport/RepairCount/RichTextLabel.text = repair_string
