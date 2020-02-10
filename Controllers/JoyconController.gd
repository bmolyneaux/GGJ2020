extends Node

const RIGHT_ANALOG = 15
const LEFT_ANALOG = 14
const UP_ANALOG = 12
const DOWN_ANALOG = 13
export(int) var player_index: int = 0
export(int) var catch_or_repair: int = 1 # Right button
export(int) var drop: int = 0 # Down button

func _physics_process(delta):
	var input := Vector2(0, 0)
	
	if Input.is_joy_button_pressed(player_index, LEFT_ANALOG):
		input.x -= 1
	if Input.is_joy_button_pressed(player_index, RIGHT_ANALOG):
		input.x += 1
	if Input.is_joy_button_pressed(player_index, UP_ANALOG):
		input.y -= 1
	if Input.is_joy_button_pressed(player_index, DOWN_ANALOG):
		input.y += 1

	input = input.clamped(1)

	get_parent().set_input(input)

func _unhandled_input(event):
	if event is InputEventJoypadButton and event.device == player_index:
		_handle_input(event as InputEventJoypadButton)

func _handle_input(event: InputEventJoypadButton):
	if not event.pressed:
		return
	if event.button_index == catch_or_repair:
		get_parent().main_action()
	if event.button_index == drop:
		get_parent().cancelly_action()
