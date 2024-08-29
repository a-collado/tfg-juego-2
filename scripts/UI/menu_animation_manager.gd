extends Node

@onready var robot: Node3D = $"../root"
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var timer: Timer = $Timer
@onready var animation_timer = $animation_timer

@export var move: bool = true

func _process(delta: float) -> void:
	if not move:
		return
	robot.global_position.x += 1 * delta
	if (robot.global_position.x > 1.60):
		robot.global_position.x = -1.60

func bat():
	animation_tree.set("parameters/Bateo/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func reset_timer():
	timer.wait_time = randi_range(1,5)
	timer.start()

func _on_timer_timeout() -> void:
	bat()
