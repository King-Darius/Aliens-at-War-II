extends Node

signal element_enqueued(element)
signal element_removed(element)
signal repeat_mode_changed(enabled)

const Moving = preload("res://source/match/units/actions/Moving.gd")


class ProductionQueueElement:
	extends Resource
	var unit_prototype = null
	var time_total = null
	var time_left = null:
		set(value):
			time_left = value
			emit_changed()

	func progress():
		return (time_total - time_left) / time_total


var repeat_enabled := false:
	set(value):
		if field == value:
			return
		field = value
		if field:
			_ensure_player_resource_observer(true)
			_flush_pending_repeats()
		else:
			_pending_repeat_counts.clear()
			_teardown_player_resource_observer()
		repeat_mode_changed.emit(field)
	get:
		return field

var _queue = []
var _pending_repeat_counts := {}

var _observed_player = null

@onready var _unit = get_parent()


func toggle_repeat_enabled():
	repeat_enabled = not repeat_enabled


func _process(delta):
	var remaining_time = delta
	while _queue.size() > 0 and remaining_time > 0.0:
		var current_queue_element = _queue.front()
		var time_spent = min(remaining_time, current_queue_element.time_left)
		current_queue_element.time_left = max(0.0, current_queue_element.time_left - time_spent)
		remaining_time -= time_spent
		if current_queue_element.time_left == 0.0:
			_remove_element(current_queue_element)
			_finalize_production(current_queue_element)
		else:
			break


func size():
	return _queue.size()


func get_elements():
	return _queue


func produce(unit_prototype, ignore_limit = false):
	if not ignore_limit and _queue.size() >= Constants.Match.Units.PRODUCTION_QUEUE_LIMIT:
		return null
	var production_cost = Constants.Match.Units.PRODUCTION_COSTS[unit_prototype.resource_path]
	if not _unit.player.has_resources(production_cost):
		MatchSignals.not_enough_resources_for_production.emit(_unit.player)
		return null
	_unit.player.subtract_resources(production_cost)
	var queue_element = ProductionQueueElement.new()
	queue_element.unit_prototype = unit_prototype
	queue_element.time_total = Constants.Match.Units.PRODUCTION_TIMES[unit_prototype.resource_path]
	queue_element.time_left = queue_element.time_total
	_enqueue_element(queue_element)
	MatchSignals.unit_production_started.emit(unit_prototype, _unit)
	_ensure_player_resource_observer()
	return queue_element


func cancel_all():
	for element in _queue.duplicate():
		cancel(element)


func cancel(element):
	if not element in _queue:
		return
	var production_cost = Constants.Match.Units.PRODUCTION_COSTS[
		element.unit_prototype.resource_path
	]
	_unit.player.add_resources(production_cost)
	_remove_element(element)


func _enqueue_element(element):
	_queue.push_back(element)
	element_enqueued.emit(element)


func _remove_element(element):
	_queue.erase(element)
	element_removed.emit(element)


func _finalize_production(former_queue_element):
	var produced_unit = former_queue_element.unit_prototype.instantiate()
	var placement_position = (
		Utils
		. Match
		. Unit
		. Placement
		. find_valid_position_radially_yet_skip_starting_radius(
			_unit.global_position,
			_unit.radius,
			produced_unit.radius,
			0.1,
			Vector3(0, 0, 1),
			false,
			find_parent("Match").navigation.get_navigation_map_rid_by_domain(
				produced_unit.movement_domain
			),
			get_tree()
		)
	)
	MatchSignals.setup_and_spawn_unit.emit(
		produced_unit, Transform3D(Basis(), placement_position), _unit.player
	)
	MatchSignals.unit_production_finished.emit(produced_unit, _unit)

	var rally_point = _unit.find_child("RallyPoint")
	if rally_point != null:
		MatchSignals.navigate_unit_to_rally_point.emit(produced_unit, rally_point)
	_handle_repeat_after_completion(former_queue_element)


func _handle_repeat_after_completion(former_queue_element):
	if not repeat_enabled:
		return
	var unit_prototype = former_queue_element.unit_prototype
	if produce(unit_prototype) == null:
		_queue_repeat_when_resources_available(unit_prototype)


func _queue_repeat_when_resources_available(unit_prototype):
	if not _pending_repeat_counts.has(unit_prototype):
		_pending_repeat_counts[unit_prototype] = 0
	_pending_repeat_counts[unit_prototype] += 1
	_ensure_player_resource_observer()


func _ensure_player_resource_observer(force := false):
	if not force and not repeat_enabled and _pending_repeat_counts.is_empty():
		return
	if _unit == null or not _unit.is_inside_tree():
		return
	if _unit.player == null:
		return
	if _observed_player == _unit.player and _observed_player != null:
		return
	if (
		_observed_player != null
		and _observed_player.changed.is_connected(_on_player_resources_changed)
	):
		_observed_player.changed.disconnect(_on_player_resources_changed)
	_observed_player = _unit.player
	if not _observed_player.changed.is_connected(_on_player_resources_changed):
		_observed_player.changed.connect(_on_player_resources_changed)


func _teardown_player_resource_observer():
	if (
		_observed_player != null
		and _observed_player.changed.is_connected(_on_player_resources_changed)
	):
		_observed_player.changed.disconnect(_on_player_resources_changed)
	_observed_player = null


func _on_player_resources_changed():
	if not repeat_enabled:
		return
	_flush_pending_repeats()


func _flush_pending_repeats():
	if _pending_repeat_counts.is_empty():
		return
	var prototypes = _pending_repeat_counts.keys()
	for unit_prototype in prototypes:
		var count = _pending_repeat_counts[unit_prototype]
		while count > 0:
			if produce(unit_prototype) != null:
				count -= 1
			else:
				break
		if count <= 0:
			_pending_repeat_counts.erase(unit_prototype)
		else:
			_pending_repeat_counts[unit_prototype] = count
