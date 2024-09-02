extends RigidBody3D
class_name Ball

@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@export var future_position_node: Node3D
@export_range(0, 0.3, 0.01) var future_position_time: float = 0.1

var frames_between_hits: int = 10
@export var last_hit: int = 0

@rpc("any_peer", "call_local", "reliable")
func kick(force: Vector3):

	print("Force: %s" % force)
	if force != Vector3.ZERO and last_hit > frames_between_hits:
		var velocity = linear_velocity / 4
		linear_velocity = Vector3(0,0,0)
		print("Velocity: %s" % velocity)
		print("Linear velocity: %s" % linear_velocity)
		apply_impulse(force - velocity)
		print("Resulting force:  %s" % (force - velocity))
		last_hit = 0
		print("HIT")

@rpc("any_peer", "call_local", "reliable")
func reset(spawn: Vector3):
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO

	transform.origin = spawn

func _process(_delta):
	var future_position = transform.origin + linear_velocity * future_position_time
	future_position_node.transform.origin = future_position

func _physics_process(_delta: float) -> void:
	last_hit += 1
