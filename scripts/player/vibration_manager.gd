class_name vibrationManager
extends Node3D

## Duracion en milisegundos de la vibración
@export var vibration_levels = [0, 10, 50, 100, 200]

func vibrate(vibration_level: int) -> void:
	if not Settings.get_config(Settings.CONFIG_NAMES.vibration):
		return
	Input.vibrate_handheld(vibration_levels[vibration_level])
