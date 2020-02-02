extends KinematicBody

export var max_speed := 10

export var acceleration_scale := 15
export (Curve) var acceleration

export var deceleration_scale := 1
export (Curve) var deceleration

export var turning_scale := 240
export (Curve) var turning

var current_speed = 0

var anim_turning = 0
var anim_accel = 0

var topdown_angle = 0

func _physics_process(delta):
	var gogogo = false
	
	if Input.is_action_pressed("ui_accept"):
		gogogo = true
		
	var normalized_speed = current_speed / max_speed
	var turning_speed = turning.interpolate(normalized_speed) * turning_scale * delta
	
	if abs(anim_turning) < 0.25:
		anim_turning = 0
	anim_turning = clamp(sign(anim_turning)*(abs(anim_turning)-0.25), -90, 90)

	
	if Input.is_action_pressed("ui_left"):
		topdown_angle += turning_speed * delta
		anim_turning = 0.95*anim_turning + 0.05*(turning_speed*3.5)
	if Input.is_action_pressed("ui_right"):
		topdown_angle -= turning_speed * delta
		anim_turning = 0.95*anim_turning - 0.05*(turning_speed*3.5)
		
	var current_rotation = get_rotation()
	current_rotation.y = topdown_angle
	current_rotation.x = anim_turning*0.1
	set_rotation(current_rotation)
	#print(topdown_angle)
		
	
	if gogogo:
		var normalized_accel = acceleration.interpolate(normalized_speed)
		var accel = normalized_accel * acceleration_scale * delta * max_speed
		current_speed = current_speed + accel
	
	else:
		var normalized_decel = deceleration.interpolate(normalized_speed)
		var decel = normalized_decel * deceleration_scale * delta * max_speed
		current_speed = current_speed - decel
	
	current_speed = clamp(current_speed, 0, max_speed)
	#print(current_speed)
	
	var mx = cos(topdown_angle)
	var mz = -sin(topdown_angle)
	
	var movement = Vector3(mx, 0, mz) * delta * current_speed
		
	move_and_collide(movement)
