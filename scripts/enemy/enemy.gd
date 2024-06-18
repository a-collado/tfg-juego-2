extends CharacterBody3D

const SPEED = 5.0

@onready var team: Team = self.get_parent()
@onready var ball_timer: Timer = $Timer
@onready var hit_manager: HitManager = $hitManager
@onready var animation_manager: animationManager = $animationManager
@onready var root = $root

var ball_cooldown: float = 0.5

func _ready() -> void:
	ball_timer.wait_time = ball_cooldown

func _physics_process(_delta: float) -> void:

	var input_dir := Vector3.ZERO
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
