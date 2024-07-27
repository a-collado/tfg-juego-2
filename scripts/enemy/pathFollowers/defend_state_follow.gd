extends CSGBox3D

@export var ball_future_pos: Node3D

var range_z := Vector2(-15, -5)

func _ready() -> void:
	pass 

func _process(_delta: float) -> void:
	transform.origin = Vector3(ball_future_pos.transform.origin.x, 0, -10)
