extends Node

# Central registry describing the external content pulled into the project.
const ORIGINS := {
	"Kenney Space Kit":
	{
		"repository": "https://www.kenney.nl/assets/space-kit",
		"asset_roots": PackedStringArray(["res://assets/kenney_space_kit"])
	},
	"KayKit City Builder Bits":
	{
		"repository": "https://github.com/KayKit-Game-Assets/KayKit-City-Builder-Bits-1.0",
		"asset_roots":
		PackedStringArray(
			[
				"res://assets/kaykit_city_builder",
				"res://third_party/kaykit-city-builder/addons/kaykit_city_builder_bits/Assets/gltf",
				"res://third_party/kaykit-city-builder/addons/kaykit_city_builder_bits/Assets/texture"
			]
		)
	},
	"Egregoria":
	{
		"repository": "https://github.com/Uriopass/Egregoria",
		"asset_roots":
		PackedStringArray(
			[
				"res://assets/egregoria/assets",
				"res://assets/egregoria/assets_gui",
				"res://third_party/egregoria/assets",
				"res://third_party/egregoria/assets_gui"
			]
		)
	},
	"Meshy Godot Plugin": {
		"repository": "https://github.com/meshy-dev/meshy-godot-plugin",
		"asset_roots": PackedStringArray(["res://addons/meshy"])
	}
}


func get_origins() -> Dictionary:
	return ORIGINS.duplicate(true)


func get_asset_roots(identifier: String) -> PackedStringArray:
	return ORIGINS.get(identifier, {}).get("asset_roots", PackedStringArray())


func describe_all() -> String:
	var summary := PackedStringArray()
	for name in ORIGINS.keys():
		var entry: Dictionary = ORIGINS[name]
		summary.append("%s -> %s" % [name, entry.get("repository", "")])
	return "\n".join(summary)


func log_origins_to_console() -> void:
	if Engine.is_editor_hint():
		print("[AssetOrigins] Registered third-party content:\n%s" % describe_all())
