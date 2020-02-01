extends KinematicBody

export var speed := 200

func _physics_process(delta):
	var input = Vector2(0, 0)
	
	if Input.is_key_pressed(KEY_W):
		input.y -= 1
	if Input.is_key_pressed(KEY_A):
		input.x -= 1
	if Input.is_key_pressed(KEY_S):
		input.y += 1
	if Input.is_key_pressed(KEY_D):
		input.x += 1
		
	var movement = Vector3(input.x, 0, input.y) * delta * speed
		
	move_and_slide(movement, Vector3(0, 1, 0))
