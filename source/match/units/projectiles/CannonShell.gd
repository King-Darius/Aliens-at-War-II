extends Node3D

const ImpactEffectScene = preload("res://source/match/effects/ImpactEffect.tscn")

var target_unit = null

@onready var _unit = get_parent()
@onready var _unit_particles = find_child("OriginParticles")
@onready var _timer = find_child("Timer")


func _ready():
	assert(target_unit != null, "target unit was not provided")
	_unit_particles.visible = _unit.visible
	_setup_unit_particles()
	_setup_timer()
	target_unit.hp -= _unit.attack_damage
	_spawn_impact_effect()


func _setup_timer():
	_timer.timeout.connect(queue_free)
	_timer.start(_unit_particles.lifetime)


func _setup_unit_particles():
	await get_tree().physics_frame  # wait for rotation to kick in if remote transform is used
	var a_global_transform = (
		_unit.global_transform
		if _unit.find_child("ProjectileOrigin") == null
		else _unit.find_child("ProjectileOrigin").global_transform
	)
	_unit_particles.global_transform = a_global_transform
	_unit_particles.emitting = true


func _spawn_impact_effect():
	if target_unit == null or not is_instance_valid(target_unit):
		return
	var effect = ImpactEffectScene.instantiate()
	effect.global_transform.origin = target_unit.global_position
	var match_node = _unit.find_parent("Match")
	if match_node != null:
		var container = match_node.get_node_or_null("Effects")
		if container != null:
			container.add_child(effect)
		else:
			match_node.add_child(effect)
	else:
		get_tree().current_scene.add_child(effect)
