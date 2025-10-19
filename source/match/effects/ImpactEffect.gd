extends Node3D

@export var lifetime: float = 0.45
@export var shake_amplitude: float = 0.25
@export var shake_duration: float = 0.18

@onready var _particles: GPUParticles3D = $GPUParticles3D
@onready var _timer: Timer = $Timer


func _ready():
	_particles.emitting = true
	_timer.wait_time = lifetime
	_timer.timeout.connect(_on_timeout)
	MatchSignals.camera_shake_requested.emit(shake_amplitude, shake_duration)


func _on_timeout():
	queue_free()
