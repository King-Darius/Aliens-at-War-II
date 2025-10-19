extends HBoxContainer

const Human = preload("res://source/match/players/human/Human.gd")

@export var resources_bar_scene: PackedScene = preload("res://source/match/hud/ResourcesBar.tscn")

@onready var _match = find_parent("Match")

var _player_to_bar := {}

# TODO: handle human player removal/addition


func _ready():
	await _match.ready
	_rebuild_bars()
	_update_visible_bars()


func _rebuild_bars():
	for child in get_children():
		child.queue_free()
	_player_to_bar.clear()
	if resources_bar_scene == null:
		return
	for player in get_tree().get_nodes_in_group("players"):
		var bar = resources_bar_scene.instantiate()
		bar.hide()
		add_child(bar)
		bar.setup(player)
		_player_to_bar[player] = bar


func _update_visible_bars():
	for bar in _player_to_bar.values():
		bar.hide()
	var players_to_show = []
	var human_players = get_tree().get_nodes_in_group("players").filter(
		func(player): return player is Human
	)
	if (
		_match.settings.visibility == _match.settings.Visibility.PER_PLAYER
		and not human_players.is_empty()
	):
		players_to_show = [human_players[0]]
	else:
		players_to_show = get_tree().get_nodes_in_group("players")
	for player in players_to_show:
		if _player_to_bar.has(player):
			_player_to_bar[player].show()
