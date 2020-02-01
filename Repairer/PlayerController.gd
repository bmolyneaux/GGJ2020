extends Node

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

	input = input.clamped(1)

	get_parent().set_input(input)
