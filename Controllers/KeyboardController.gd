extends Node

export(int) var up: int = KEY_W
export(int) var down: int = KEY_S
export(int) var left: int = KEY_A
export(int) var right: int = KEY_D
export(int) var catch_or_repair: int = KEY_SPACE

func _physics_process(delta):
	var input = Vector2(0, 0)
	
	if Input.is_key_pressed(up):
		input.y -= 1
	if Input.is_key_pressed(down):
		input.y += 1
	if Input.is_key_pressed(left):
		input.x -= 1
	if Input.is_key_pressed(right):
		input.x += 1

	input = input.clamped(1)

	get_parent().set_input(input)

func _unhandled_key_input(event):
	if event.pressed and event.scancode == catch_or_repair:
		get_parent().main_action()
