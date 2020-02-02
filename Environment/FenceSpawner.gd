extends Spatial
tool

var old_start
var old_end

export(float) var jank := 1

var fence_width : float = 1

var fences = [
	preload("res://Environment/fence1.mesh"),
	preload("res://Environment/fence2.mesh"),
	preload("res://Environment/fence3.mesh"),
	preload("res://Environment/fence4.mesh")
]

var rng = RandomNumberGenerator.new()

func randomize_transform(mesh):
	if jank == 0:
		return
	
	rng.randomize()
	var index = rng.randi_range(0, 3)
	mesh.mesh = fences[index]
	
	var yaw = rng.randf_range(-0.1, .1) * jank
	mesh.rotate_y(yaw)
	
	var pitch = rng.randf_range(-0.05, .05) * jank
	mesh.rotate_x(pitch)
	
	var roll = rng.randf_range(-0.05, .05) * jank
	mesh.rotate_z(roll)
	
	var scale = rng.randf_range(0.98, 1.02) * 0.01 * jank
	mesh.scale = Vector3(scale, scale, scale)

func _ready():
	regenerate_fn(true)
	
	set_process(Engine.editor_hint)
	
func _process(delta):
	if Engine.editor_hint:
		regenerate_fn(true)

func regenerate_fn(value):
	#var start_node = get_node(start_path)
	#var end_node = get_node(end_path)
	
	var start_node = $Start
	var end_node = $End
	
	if not start_node or not end_node:
		return
	
	var start = start_node.translation
	var end = end_node.translation
	
	if start == old_start and end == old_end:
		return
	
	old_start = start
	old_end = end
	
	for child in get_children():
		if child is MeshInstance or child is StaticBody:
			remove_child(child)
	
	var length = start.distance_to(end)
	var pieces = int(floor(length / fence_width))
	
	var delta = end - start
	var angle = atan2(-delta.z, delta.x)
	
	for piece in range(0, pieces):
		var mesh = MeshInstance.new()
		mesh.mesh = fences[0]
		mesh.scale = Vector3(0.01, 0.01, 0.01)
		var z = piece / float(pieces)
		mesh.translation = lerp(start, end, z) + delta.normalized() / 2.0 + Vector3(0, -0.05, 0)
		mesh.rotate_y(angle)
		mesh.rotate_x(-0.4)
		mesh.use_in_baked_light = true
		randomize_transform(mesh)
		add_child(mesh)
		
	var static_body = StaticBody.new()
	static_body.translation = (start + end) / 2.0 + Vector3(0, 0.5, 0)
	static_body.rotate_y(angle)
	add_child(static_body)
	
	var collision = CollisionShape.new()
	collision.shape = BoxShape.new()
	collision.scale = Vector3(0.5 * length, 0.5, 0.1)
	static_body.add_child(collision)
	
