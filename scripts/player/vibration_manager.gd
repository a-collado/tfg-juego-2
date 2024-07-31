class_name vibrationManager
extends Node3D

## Indica si la vibración esta activada
@export var enabled := true
## Duracion en milisegundos de la vibración
@export var vibration_levels = [0, 10, 50, 100, 200]

func vibrate(vibration_level: int) -> void:
	if not enabled:
		return
	Input.vibrate_handheld(vibration_levels[vibration_level])
