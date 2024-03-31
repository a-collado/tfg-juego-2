extends RigidBody3D
class_name Ball

#@onready var area3d: Area3D = $Area3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

func _ready() -> void:
	#linear_velocity = Vector3.FORWARD * 10
	pass

func _process(delta: float) -> void:
	pass


