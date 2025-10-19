extends Node3D

@export var shake_amplitude: float = 0.6
@export var shake_duration: float = 0.3

@onready var _particles: GPUParticles3D = $GPUParticles3D


func _ready():
	_particles.emitting = true
	_particles.finished.connect(_on_particles_finished)
	MatchSignals.camera_shake_requested.emit(shake_amplitude, shake_duration)


func _on_particles_finished():
	queue_free()
