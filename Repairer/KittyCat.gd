extends Spatial

var num_casettes := 0

func _ready():
	set_casettes(0)

func set_casettes(num):
	num_casettes = num
	var casettes = $Armature/Skeleton/Casettes.get_children()
	for i in range(casettes.size()):
		casettes[i].visible = ((i + 1) <= num)
