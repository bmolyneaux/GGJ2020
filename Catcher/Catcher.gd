extends KinematicBody

export(int) var index := 0
export var acceleration := 10
export var max_speed := 200
export var tackle_speed_scale := 2.0

export(Curve)  var tackle_speed_curve

# TODO: Gravity should be an acceleration
export var gravity_speed := -150
var speed := Vector2(0, 0)
var input : Vector2
var num_caught := 0

func _ready():
	add_to_group("player")
	$PuppyDog.get_node("AnimationPlayer").get_animation("Walk").loop = true
	$PuppyDog.get_node("AnimationPlayer").play("Walk")

func _physics_process(delta):
	var desired_speed = input * max_speed * get_diving_speed_multiplier()
	
	speed = lerp(speed, desired_speed, 0.2)
	
	var movement = Vector3(speed.x, gravity_speed, speed.y) * delta
		
	var actual_movement = move_and_slide(movement, Vector3(0, 1, 0))
	$PuppyDog.rotation = Vector3(0, atan2(speed.y, -speed.x),0)
	$PuppyDog.rotate_x(-0.4)
	
	var is_moving = actual_movement.length_squared() > 0.01
	if is_tackling():
		pass
	else:
		if is_moving:
			$PuppyDog.get_node("AnimationPlayer").play("Walk")
		else:
			$PuppyDog.get_node("AnimationPlayer").play("Idle")
	$RunParticles.emitting = is_moving

	var bodies = $Area.get_overlapping_bodies()
	for body in bodies:
		# Check for catching the skating kiddos
		if not body is Repairer:
			continue
		var repairer := body as Repairer
		if repairer.can_be_caught():
			repairer.get_caught()
			num_caught += 1

func get_diving_speed_multiplier():
	if not is_tackling():
		return 1
	var anim_player = $PuppyDog.get_node("AnimationPlayer")
	var anim_amt = anim_player.get_current_animation_position() / anim_player.get_current_animation_length()

	return tackle_speed_curve.interpolate(anim_amt) * tackle_speed_scale

func is_tackling():
	return $PuppyDog.get_node("AnimationPlayer").get_current_animation() == "Tackle" and $PuppyDog.get_node("AnimationPlayer").is_playing()

func set_input(value : Vector2):
	if not is_tackling():
		input = value

func main_action():
	$PuppyDog.get_node("AnimationPlayer").play("Tackle", -1, 0.75)

func cancelly_action():
	pass
