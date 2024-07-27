extends CSGBox3D

@export var ball_future_pos: Node3D

@export_range(0,360,1) var change_timeout: int = 60
## Variación que puede haber al seguir a la pelota en el eje X
@export var offset_x_range := Vector2(-1,1)

var range_z := Vector2(-15.0, -5.0)
var position_z: float = -10
var offset_x: float = 0
var time_since_change: int = 0

func _physics_process(_delta: float) -> void:
	if time_since_change > change_timeout:
		time_since_change = 0
		position_z = randf_range(range_z[0], range_z[1])
		offset_x = randf_range(-1, 1)
	time_since_change += 1
	transform.origin = Vector3(ball_future_pos.transform.origin.x + offset_x, 0, position_z)
