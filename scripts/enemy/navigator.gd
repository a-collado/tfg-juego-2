extends Node3D
class_name Navigator

@onready var direction := Vector3.ZERO

func getNavInput() -> Vector3:
	return direction

func setNavInput(dir: Vector3):
	direction = dir
