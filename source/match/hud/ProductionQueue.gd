extends MarginContainer

const ProductionQueueElement = preload("res://source/match/hud/ProductionQueueElement.tscn")

var _production_queue = null
var _repeat_mode_callable = Callable()

@onready var _queue_elements = find_child("QueueElements")
@onready var _repeat_toggle_button = find_child("RepeatToggleButton")


func _ready():
	_reset()
	_repeat_toggle_button.toggled.connect(_on_repeat_toggled)
	_repeat_mode_callable = Callable(self, "_on_repeat_mode_changed")
	MatchSignals.unit_selected.connect(func(_unit): _reset())
	MatchSignals.unit_deselected.connect(func(_unit): _reset())


func _reset():
	if not is_inside_tree():
		return
	_detach_observed_production_queue()
	_try_observing_production_queue()
	visible = _is_observing_production_queue()
	_remove_queue_element_nodes()
	_try_rendering_queue()
	_sync_repeat_toggle()


func _remove_queue_element_nodes():
	for child in _queue_elements.get_children():
		child.queue_free()


func _is_observing_production_queue():
	return _production_queue != null


func _detach_observed_production_queue():
	if _production_queue != null:
		_production_queue.element_enqueued.disconnect(_on_production_queue_element_enqueued)
		_production_queue.element_removed.disconnect(_on_production_queue_element_removed)
		if _production_queue.repeat_mode_changed.is_connected(_repeat_mode_callable):
			_production_queue.repeat_mode_changed.disconnect(_repeat_mode_callable)
		_production_queue = null


func _try_observing_production_queue():
	var selected_controlled_units = get_tree().get_nodes_in_group("selected_units").filter(
		func(unit): return unit.is_in_group("controlled_units")
	)
	if selected_controlled_units.size() != 1:
		return
	var selected_unit = selected_controlled_units[0]
	if not "production_queue" in selected_unit or selected_unit.production_queue == null:
		return
	_observe(selected_unit.production_queue)


func _observe(production_queue):
	_production_queue = production_queue
	_production_queue.element_enqueued.connect(_on_production_queue_element_enqueued)
	_production_queue.element_removed.connect(_on_production_queue_element_removed)
	if not _production_queue.repeat_mode_changed.is_connected(_repeat_mode_callable):
		_production_queue.repeat_mode_changed.connect(_repeat_mode_callable)
	_sync_repeat_toggle()


func _try_rendering_queue():
	if not _is_observing_production_queue():
		return
	for queue_element in _production_queue.get_elements():
		_add_queue_element_node(queue_element)


func _add_queue_element_node(queue_element):
	var queue_element_node = ProductionQueueElement.instantiate()
	queue_element_node.queue = _production_queue
	queue_element_node.queue_element = queue_element
	_queue_elements.add_child(queue_element_node)
	_queue_elements.move_child(queue_element_node, 0)


func _on_production_queue_element_enqueued(element):
	_add_queue_element_node(element)


func _on_production_queue_element_removed(element):
	(
		_queue_elements
		. get_children()
		. filter(func(queue_element_node): return queue_element_node.queue_element == element)
		. map(func(queue_element_node): queue_element_node.queue_free())
	)


func _sync_repeat_toggle():
	if not is_instance_valid(_repeat_toggle_button):
		return
	var observing_queue = _is_observing_production_queue()
	_repeat_toggle_button.disabled = not observing_queue
	if not observing_queue:
		_repeat_toggle_button.button_pressed = false
		_repeat_toggle_button.tooltip_text = tr(
			"Enable repeat production to keep factories cycling automatically."
		)
		return
	_repeat_toggle_button.button_pressed = _production_queue.repeat_enabled
	_repeat_toggle_button.tooltip_text = (
		tr("Factory queues repeat when resources are available.")
		if _repeat_toggle_button.button_pressed
		else tr("Enable repeat production to keep factories cycling automatically.")
	)


func _on_repeat_mode_changed(enabled):
	if not is_instance_valid(_repeat_toggle_button):
		return
	_repeat_toggle_button.button_pressed = enabled
	_repeat_toggle_button.tooltip_text = (
		tr("Factory queues repeat when resources are available.")
		if enabled
		else tr("Enable repeat production to keep factories cycling automatically.")
	)


func _on_repeat_toggled(pressed):
	if not _is_observing_production_queue():
		return
	_production_queue.repeat_enabled = pressed
