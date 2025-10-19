extends Node3D

var _tracked_units := {}
var _active_units := {}
var _player = null


func _ready():
	_player = get_parent() if get_parent() != null else null
	MatchSignals.unit_spawned.connect(_on_unit_spawned)
	MatchSignals.unit_died.connect(_on_unit_died)
	MatchSignals.unit_selected.connect(_on_unit_selected)
	MatchSignals.unit_deselected.connect(_on_unit_deselected)
	_bootstrap_existing_units()


func issue_move_command(target_position: Vector3, units_to_move: Array):
	var active_now := {}
	for entry in units_to_move:
		var unit = entry if not (entry is Array) else entry[0]
		if not _is_swarm_candidate(unit):
			continue
		_register_unit(unit)
		active_now[unit] = true
		var movement = unit.find_child("Movement")
		if movement != null:
			movement.set_swarm_target(target_position)
	for unit in _active_units.keys():
		if active_now.has(unit):
			continue
		var movement = unit.find_child("Movement")
		if movement != null:
			movement.clear_swarm_target()
	_active_units = active_now


func _bootstrap_existing_units():
	for unit in get_tree().get_nodes_in_group("units"):
		_register_unit(unit)


func _is_swarm_candidate(unit) -> bool:
	if unit == null or not is_instance_valid(unit):
		return false
	if unit.find_child("Movement") == null:
		return false
	if _player != null and unit.player != _player:
		return false
	return unit.is_in_group("controlled_units")


func _register_unit(unit):
	if not _is_swarm_candidate(unit):
		return
	if _tracked_units.has(unit):
		return
	_tracked_units[unit] = true
	unit.tree_exited.connect(_on_unit_tree_exited.bind(unit), CONNECT_ONESHOT)
	if not unit.is_in_group("swarm_units"):
		unit.add_to_group("swarm_units")
	var movement = unit.find_child("Movement")
	if movement != null:
		movement.set_swarm_controller(self)


func _unregister_unit(unit):
	if unit == null or not _tracked_units.has(unit):
		return
	_tracked_units.erase(unit)
	_active_units.erase(unit)
	if unit.is_in_group("swarm_units"):
		unit.remove_from_group("swarm_units")
	var movement = unit.find_child("Movement")
	if movement != null:
		movement.set_swarm_controller(null)
		movement.clear_swarm_target()


func _on_unit_spawned(unit):
	_register_unit(unit)


func _on_unit_died(unit):
	_unregister_unit(unit)


func _on_unit_tree_exited(unit):
	_unregister_unit(unit)


func _on_unit_selected(unit):
	_register_unit(unit)


func _on_unit_deselected(unit):
	if unit == null:
		return
	if not _active_units.has(unit):
		return
	var movement = unit.find_child("Movement")
	if movement != null:
		movement.clear_swarm_target()
	_active_units.erase(unit)
