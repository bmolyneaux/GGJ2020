extends Spatial

export(float) var jank := 1

var fences = [
	preload("res://Environment/fence1.mesh"),
	preload("res://Environment/fence2.mesh"),
	preload("res://Environment/fence3.mesh"),
	preload("res://Environment/fence4.mesh")
]

var rng = RandomNumberGenerator.new()

func _ready():
	if jank == 0:
		return
	
	rng.randomize()
	var index = rng.randi_range(0, 3)
	$MeshInstance.mesh = fences[index]
	
	var yaw = rng.randf_range(-0.1, .1) * jank
	$MeshInstance.rotate_y(yaw)
	
	var pitch = rng.randf_range(-0.05, .05) * jank
	$MeshInstance.rotate_x(pitch)
	
	var roll = rng.randf_range(-0.05, .05) * jank
	$MeshInstance.rotate_z(roll)
	
	var scale = rng.randf_range(0.98, 1.02) * 0.01 * jank
	$MeshInstance.scale = Vector3(scale, scale, scale)
	
	
