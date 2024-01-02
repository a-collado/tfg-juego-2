extends CSGSphere3D
class_name Ball

@onready var area3d: Area3D = $Area3D
@onready var collision_shape: CollisionShape3D = $Area3D/CollisionShape3D
var player: Player
var tween: Tween

func stop() -> void:
	if tween:
		tween.stop()
