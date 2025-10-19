extends Button

const Constants = preload("res://source/Constants.gd")

var queue = null
var queue_element = null


func _ready():
	if queue == null or queue_element == null:
		return
	queue_element.changed.connect(_on_queue_element_changed)
	pressed.connect(func(): queue.cancel(queue_element))
	toggle_mode = false
	var resource_path = queue_element.unit_prototype.resource_path
	var unit_label = resource_path.get_file().get_basename().replace("_", " ")
	text = unit_label.capitalize()
	_update_progress_label()
	tooltip_text = _format_tooltip(resource_path)


func _on_queue_element_changed():
	_update_progress_label()


func _update_progress_label():
	var progress_percent = int(queue_element.progress() * 100.0)
	find_child("Label").text = "{0}%".format([progress_percent])


func _format_tooltip(resource_path):
	var cost = Constants.Match.Units.PRODUCTION_COSTS.get(resource_path, {})
	var time_total = Constants.Match.Units.PRODUCTION_TIMES.get(resource_path, 0.0)
	var time_string = String.num(time_total, 1)
	var lines = [
		text,
		tr("Cost: %s / %s") % [cost.get("resource_a", 0), cost.get("resource_b", 0)],
		tr("Build time: %s s") % time_string,
		tr("Click to cancel this order."),
	]
	return "\n".join(lines)
