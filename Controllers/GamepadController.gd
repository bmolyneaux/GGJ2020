extends Node

const DEADZONE_RATIO = 0.1;
const HORIZONTAL_AXIS = JOY_AXIS_0
const VERTICAL_AXIS = JOY_AXIS_1
export(int) var player_index: int = 0
export(int) var catch_or_repair: int = JOY_XBOX_A

func _on_joy_connection_changed(device_id, connected):
	print("Connection change. This device: %s, %s. Total: %s" % [device_id, connected, Input.get_connected_joypads().size()])

func _physics_process(delta):
	var input := Vector2(0, 0)
	
	var hori = Input.get_joy_axis(player_index, HORIZONTAL_AXIS)
	var vert = Input.get_joy_axis(player_index, VERTICAL_AXIS)
	input.x = _apply_deadzone(hori, DEADZONE_RATIO)
	input.y = _apply_deadzone(vert, DEADZONE_RATIO)
	
	input = input.clamped(1)

	get_parent().set_input(input)

func _apply_deadzone(original, deadzone):
	if original > deadzone:
		return (original - deadzone) / (1 - deadzone)
	if original < -deadzone:
		return (original + deadzone) / (1 - deadzone)
	return 0

func _unhandled_input(event):
	if event is InputEventJoypadButton and event.device == player_index:
		_handle_input(event as InputEventJoypadButton)

func _handle_input(event: InputEventJoypadButton):
	if event.pressed and event.button_index == catch_or_repair:
		get_parent().main_action()
