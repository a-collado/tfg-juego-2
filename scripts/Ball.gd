extends RigidBody3D
class_name Ball

@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@export var future_position_node: Node3D
@export_range(0, 0.3, 0.01) var future_position_time: float = 0.1

@rpc("any_peer", "call_local", "reliable")
func kick(force: Vector3):
	apply_impulse(force)

@rpc("any_peer", "call_local", "reliable")
func reset(spawn: Vector3):
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO

	transform.origin = spawn

func _process(_delta):
	var future_position = transform.origin + linear_velocity * future_position_time
	future_position_node.transform.origin = future_position
