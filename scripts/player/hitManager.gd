extends Node3D
class_name HitManager

signal hit_ball(charge_level: int)

#@onready var player: Player = $".."
@onready var charge_bar: ChargeBar = $SubViewport/ChargeBar
@onready var charging_particles: CPUParticles3D = $CPUParticles3D
@onready var hitArea: Area3D = $"../hitNodes/hitArea"

@export var charge_times: PackedFloat32Array = [0.2, 0.5, 1]
@export_range(5, 500) var kick_force: float = 50
@export var hit_forces: PackedInt32Array = [0, 25, 50, 75]

var charging:bool = false;
var charged:bool = false;
var charge_level: int = 0;

func _ready() -> void:
	hitArea.monitoring = false
	charge_bar.texture_progress_bar_0.max_value = charge_times[0]
	charge_bar.texture_progress_bar_1.max_value = charge_times[1]
	charge_bar.texture_progress_bar_2.max_value = charge_times[2]

func _process(_delta: float) -> void:

	if charging and not charged and not charge_bar.charging:
		charge_bar.charge(true)

	if not charging:
		charge_bar.charge(false)
		charge_bar.reset()
		if charge_bar.charge_level != 0:
			hit_ball.emit(charge_bar.charge_level)
			charge_bar.charge_level = 0

func get_kick_force() -> float:
	return hit_forces[charge_level]
