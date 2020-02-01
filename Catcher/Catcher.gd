extends KinematicBody

export var acceleration := 10
export var max_speed := 200
var speed := Vector2(0, 0)
var input : Vector2
var num_caught := 0

func _physics_process(delta):
	var desired_speed = input * max_speed
	
	speed = lerp(speed, desired_speed, 0.2)
	
	var movement = Vector3(speed.x, 0, speed.y) * delta
		
	move_and_slide(movement, Vector3(0, 1, 0))

	var bodies = $Area.get_overlapping_bodies()
	for body in bodies:
		# Check for catching the skating kiddos
		if not body.is_in_group("Player"):
			return
		var repairer := body as Repairer
		if repairer.can_be_caught():
			repairer.get_caught()
			num_caught += 1

func set_input(value : Vector2):
	input = value

func main_action():
	# Nothing yet.
	pass