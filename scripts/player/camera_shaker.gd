class_name CameraShaker
extends Node3D

@export var shake_levels := [0.0, 0.01, 0.4, 1, 0.15]
var camera: Camera3D
var camera_shake_noise: FastNoiseLite

func _ready() -> void:
	camera_shake_noise = FastNoiseLite.new()

func shake_camera(shake_level: int) -> void:
	var camera_tween = get_tree().create_tween()
	var intensity: float = shake_levels[shake_level]
	camera_tween.tween_method(_start_camera_shake, intensity, 0.05, 0.05)

func _start_camera_shake(intensity: float) -> void:
	var camera_offset = camera_shake_noise.get_noise_1d(
	Time.get_ticks_msec()) * intensity
	camera.h_offset = camera_offset
	camera.v_offset = camera_offset


