extends Node

const Options = preload("res://source/data-model/Options.gd")

var options = (
	load(Constants.OPTIONS_FILE_PATH)
	if ResourceLoader.exists(Constants.OPTIONS_FILE_PATH)
	else Options.new()
)
var god_mode = false
var cache = {}
var imported_content_summary := ""


func _ready():
	_register_third_party_content()


func _unhandled_input(event):
	if event.is_action_pressed("toggle_god_mode"):
		_toggle_god_mode()


func _toggle_god_mode():
	if not FeatureFlags.god_mode:
		return
	god_mode = not god_mode
	if god_mode:
		Signals.god_mode_enabled.emit()
	else:
		Signals.god_mode_disabled.emit()


func _register_third_party_content():
	var registry := get_tree().root.get_node_or_null("AssetOrigins")
	if registry == null:
		push_warning(
			"AssetOrigins autoload not found; third-party assets will not be advertised."
		)
		return
	if registry.has_method("describe_all"):
		imported_content_summary = registry.describe_all()
	if registry.has_method("log_origins_to_console"):
		registry.log_origins_to_console()
