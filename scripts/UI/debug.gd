extends Control

@onready var ball: Ball = %Ball
@onready var ball_spawn_A: Marker3D = $"../../Team A/Ball Spawn A"

func _on_return_ball_pressed():
	ball.reset(ball_spawn_A.position)
