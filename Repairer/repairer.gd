extends KinematicBody
class_name Repairer

export var acceleration := 10
export var max_speed := 200
var speed := Vector2(0, 0)
var input : Vector2
var numCollected := 0

func _physics_process(delta):
	var desired_speed = input * max_speed
	
	speed = lerp(speed, desired_speed, 0.2)
	
	var movement = Vector3(speed.x, 0, speed.y) * delta
		
	move_and_slide(movement, Vector3(0, 1, 0))
	
	# Look for cool CD-ROMs
	var bodies = $Area.get_overlapping_bodies()
	for body in bodies:
		var collectable = body.get_parent()
		if not collectable.is_in_group("Collectable"):
			continue
		if collectable.collected:
			continue
		collectable.collect()
		numCollected += 1

func set_input(value : Vector2):
	input = value

func _unhandled_key_input(event):
	if event.pressed and event.scancode == KEY_SPACE:
		repair()

func repair():
	var bodies = $Area.get_overlapping_bodies()
	for body in bodies:
		var repairable = body.get_parent()
		if not repairable.is_in_group("Repairable"):
			continue
		repairable.repair()
