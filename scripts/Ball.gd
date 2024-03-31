extends RigidBody3D
class_name Ball

@onready var collision_shape: CollisionShape3D = $CollisionShape3D

@rpc("any_peer", "call_local", "reliable")
func kick(force: Vector3):
	apply_impulse(force)
