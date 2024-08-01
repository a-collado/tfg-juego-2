extends Node3D

@export var test: Node3D
@export_range(0, 2) var sensibility: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	var gyro_rotation = Input.get_gravity()
	test.rotation.y = -gyro_rotation.x * sensibility
