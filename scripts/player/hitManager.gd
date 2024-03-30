extends Node3D
class_name HitManager

signal hit_ball

@onready var player: Player = $".."
@onready var charge_bar: ChargeBar = $SubViewport/ChargeBar
@onready var charging_particles: CPUParticles3D = $CPUParticles3D

@export_range(0, 10) var charge_time: float = 1.5

var charging = false;
var charged = false;

func _ready() -> void:
	charge_bar.connect("charge_complete", set_charged)
	charge_bar.texture_progress_bar.max_value = charge_time

func _process(delta: float) -> void:
	#charging_particles.emitting = player.is_joystick_pressed

	if charging and not charged and not charge_bar.charging:
		charge_bar.charge(true)
	if not charging and not charged and charge_bar.charging:
		charge_bar.reset()
	if not charging and charged:
		hit_ball.emit()
		charged = false
		charge_bar.reset()

func set_charged():
	print("Charged")
	charged = true

