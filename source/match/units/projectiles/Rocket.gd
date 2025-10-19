extends Node3D

const ExplosionScene = preload("res://source/match/effects/Explosion.tscn")

var target_unit = null

@onready var _unit = get_parent()
@onready var _visuals = find_child("Visuals")
@onready var _path = find_child("Path3D")
@onready var _animation_player = find_child("AnimationPlayer")
@onready var _rocket = find_child("MeshInstance3D")
@onready var _trail = find_child("TrailParticles")


func _ready():
	assert(target_unit != null, "target unit was not provided")
	_visuals.visible = _unit.visible
	_rocket.hide()
	if _trail != null:
		_trail.emitting = true
	target_unit.tree_exited.connect(queue_free)
	_animation_player.animation_finished.connect(func(_animation): queue_free())
	_setup_path()
	# wait 2 frames for path curve setup so that path follow has correct transform
	await get_tree().physics_frame
	await get_tree().physics_frame
	_animation_player.play("animate")


func _physics_process(_delta):
	_path.curve.set_point_position(1, target_unit.global_position)


func _setup_path():
	var projectile_origin = (
		_unit.global_position
		if _unit.find_child("ProjectileOrigin") == null
		else _unit.find_child("ProjectileOrigin").global_position
	)
	_path.curve.add_point(projectile_origin)
	_path.curve.add_point(target_unit.global_position)


func _perform_hit():
	target_unit.hp -= _unit.attack_damage
	_spawn_explosion()
	if _trail != null:
		_trail.emitting = false


func _spawn_explosion():
	if target_unit == null or not is_instance_valid(target_unit):
		return
	var explosion = ExplosionScene.instantiate()
	explosion.global_transform.origin = target_unit.global_position
	var match_node = _unit.find_parent("Match")
	if match_node != null:
		var container = match_node.get_node_or_null("Effects")
		if container != null:
			container.add_child(explosion)
		else:
			match_node.add_child(explosion)
	else:
		get_tree().current_scene.add_child(explosion)
