extends CanvasLayer

const MatchUtils = preload("res://source/match/MatchUtils.gd")
const Utils = preload("res://source/Utils.gd")

@onready var _hotkey_label: Label = %HotkeyLabel
@onready var _match = find_parent("Match")


func _ready():
	_ensure_input_actions()
	_update_hotkey_label()
	set_process_unhandled_input(true)


func _unhandled_input(event):
	if event.is_action_pressed("hotkey_command_move"):
		_issue_move_command_from_cursor()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("hotkey_select_all"):
		_select_all_units()
		get_viewport().set_input_as_handled()


func _ensure_input_actions():
	if not InputMap.has_action("hotkey_command_move"):
		InputMap.add_action("hotkey_command_move")
	var move_event := InputEventKey.new()
	move_event.physical_keycode = KEY_M
	move_event.keycode = KEY_M
	_add_action_event_once("hotkey_command_move", move_event)
	if not InputMap.has_action("hotkey_select_all"):
		InputMap.add_action("hotkey_select_all")
	var select_event := InputEventKey.new()
	select_event.physical_keycode = KEY_A
	select_event.keycode = KEY_A
	select_event.ctrl_pressed = true
	_add_action_event_once("hotkey_select_all", select_event)


func _add_action_event_once(action_name: StringName, event: InputEvent):
	for existing in InputMap.action_get_events(action_name):
		if existing.as_text() == event.as_text():
			return
	InputMap.action_add_event(action_name, event)


func _update_hotkey_label():
	if _hotkey_label == null:
		return
	_hotkey_label.text = "M: Move | Ctrl+A: Select All"


func _issue_move_command_from_cursor():
	var camera = get_viewport().get_camera_3d()
	if camera == null:
		return
	var mouse_position = get_viewport().get_mouse_position()
	var origin = camera.project_ray_origin(mouse_position)
	var direction = camera.project_ray_normal(mouse_position)
	var space_state = camera.get_world_3d().direct_space_state
	var result = space_state.intersect_ray(origin, origin + direction * 2048)
	if result.is_empty():
		return
	var position = result.get("position", null)
	if position == null:
		return
	MatchSignals.terrain_targeted.emit(position)


func _select_all_units():
	var controlled_units = get_tree().get_nodes_in_group("controlled_units")
	if controlled_units.is_empty():
		return
	var selection = Utils.Set.from_array(controlled_units)
	MatchUtils.select_units(selection)
