extends KinematicBody
class_name Repairer

export(int) var index := 0
export var acceleration := 10
export var regular_speed := 250
export var carry_speed := 150
export var hurt_speed := 400
# TODO: Gravity should be an acceleration
export var gravity_speed := -150
var speed := Vector2(0, 0)
var input : Vector2
var num_collected := 0
var caught_cooldown := 0.0
const caught_cooldown_length := 3.0
export(SpatialMaterial) var body_skin : SpatialMaterial
export(SpatialMaterial) var face_skin : SpatialMaterial

const cd_node := preload("res://Collectables/Collectable.tscn")

var rng := RandomNumberGenerator.new()

func _ready():
	add_to_group("player")
	$KittyCat.get_node("AnimationPlayer").get_animation("Idle").loop = true
	$KittyCat.get_node("AnimationPlayer").get_animation("Walk").loop = true
	$KittyCat.get_node("AnimationPlayer").get_animation("HoldingIdle").loop = true
	$KittyCat.get_node("AnimationPlayer").get_animation("Holding Walk").loop = true
	$KittyCat.get_node("AnimationPlayer").play("Walk")
	$KittyCat.get_node("AnimationPlayer").set_default_blend_time(0.2)
	rng.randomize()
	
	if body_skin:
		$KittyCat.get_node("Armature/Skeleton/Mesh").set_surface_material(0, body_skin)
	if face_skin:
		$KittyCat.get_node("Armature/Skeleton/Mesh").set_surface_material(1, face_skin)

func _physics_process(delta):
	var desired_speed = input * get_speed()
	
	speed = lerp(speed, desired_speed, 0.2)
	
	var movement = Vector3(speed.x, gravity_speed, speed.y) * delta
		
	move_and_slide(movement, Vector3(0, 1, 0))
	$KittyCat.rotation = Vector3(0, atan2(speed.y, -speed.x),0)
	$KittyCat.rotate_x(-0.4)

	var moving := speed.length_squared() > 50 * 50
	var anim_player = $KittyCat.get_node("AnimationPlayer")
	if anim_player.get_current_animation() == "Tackled" and anim_player.is_playing():
		pass
	else:
		if num_collected > 0:
			if moving:
				$KittyCat.get_node("AnimationPlayer").play("Holding Walk")
			else:
				$KittyCat.get_node("AnimationPlayer").play("HoldingIdle")
		else:
			if moving:
				$KittyCat.get_node("AnimationPlayer").play("Walk")
			else:
				$KittyCat.get_node("AnimationPlayer").play("Idle")
			
	var is_walking = $KittyCat.get_node("AnimationPlayer").current_animation == "Walk"
	$RunParticles.emitting = is_walking

	if caught_cooldown <= 0:
		_pick_up_nearby_cds()

func _process(delta):
	if caught_cooldown > 0:
		caught_cooldown -= delta
		if caught_cooldown < 0:
			caught_cooldown = 0

# Reacting to inputs
func set_input(value : Vector2):
	input = value

func main_action():
	repair()

func cancelly_action():
	if num_collected <= 0:
		return
	_drop_cd()
	$DropSfx.play()

func _pick_up_nearby_cds():
	# Look for cool CD-ROMs
	var bodies = $Area.get_overlapping_areas()
	for body in bodies:
		var collectable = body.get_parent()
		if not collectable.is_in_group("Collectable"):
			continue
		if not collectable.can_collect():
			continue
		collectable.collect()
		num_collected += 1
		$KittyCat.set_casettes(num_collected)
		$PickupSfx.play()

func _drop_all_cds():
	for i in range(num_collected):
		_drop_cd()
	num_collected = 0

func _drop_cd():
	var cd := cd_node.instance() as Collectable
	cd.translation = (
		translation
		+ (rng.randf_range(-1, 1) * Vector3.LEFT)
		+ (rng.randf_range(-1, 1) * Vector3.FORWARD)
	)
	cd.be_dropped()
	get_parent().add_child(cd)
	num_collected -= 1
	$KittyCat.set_casettes(num_collected)

func repair():
	if num_collected <= 0:
		# Can't repair if you're not holding anything
		return
	var bodies = $Area.get_overlapping_bodies()
	for body in bodies:
		if not body.get_parent().is_in_group("Repairable"):
			continue
		if not body.get_parent() is Repairable:
			print("Things tagged with Repairable should be Repairable things")
			continue
		var repairable := body.get_parent() as Repairable
		if repairable.repaired:
			continue
		repairable.repair()
		num_collected -= 1
		$KittyCat.set_casettes(num_collected)

func can_be_caught():
	return caught_cooldown <= 0

func get_caught():
	_drop_all_cds()
	caught_cooldown = caught_cooldown_length
	$KittyCat.get_node("AnimationPlayer").play("Tackled")
	$FallSfx.play()

func get_speed():
	if caught_cooldown > 0:
		return hurt_speed
	if num_collected > 0:
		return carry_speed
	return regular_speed
