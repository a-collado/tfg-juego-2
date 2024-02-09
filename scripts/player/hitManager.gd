extends Node3D
class_name HitManager

@onready var player: Player = $".."
@onready var charging_particles: CPUParticles3D = $CPUParticles3D

var charging = false;

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	charging_particles.emitting = player.is_joystick_pressed

