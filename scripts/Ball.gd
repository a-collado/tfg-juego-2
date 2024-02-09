extends RigidBody3D
class_name Ball

#@onready var area3d: Area3D = $Area3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
var player: Player

func _ready() -> void:
	linear_velocity = Vector3.FORWARD * 10

func _process(delta: float) -> void:
	pass
