extends CharacterBody3D
class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var ball: Ball = %Ball
@onready var team: Team = self.get_parent()
@onready var ball_timer: Timer = $Timer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var ball_cooldown: float = 0.5
var movement: bool = true

func _ready() -> void:
	ball_timer.wait_time = ball_cooldown

func _physics_process(delta: float) -> void:
	if movement:
		_calc_movement(delta)
	else:
		throw_ball()

func _calc_movement(delta: float) -> void:
		# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector( "ui_right", "ui_left", "ui_down" , "ui_up")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _on_player_area_area_entered(area: Area3D) -> void:
	# Comprobamos si el jugador ha tocado la pelota
	var detected_ball = area.get_parent()
	if detected_ball is Ball && detected_ball.player == null:
		attach_ball(area)
		throw_ball()

## Transferimos la posesion del balon al jugador
func attach_ball(area) -> void:
	# Esto aun esta a medias:
	if !ball_timer.is_stopped():
		return
	print("Ball is attached")
	ball.player = self
	ball = area.get_parent()
	ball.stop()
	ball.collision_shape.set_deferred("disabled", true)
	ball.reparent(self)
	ball.position = Vector3(0, 0.004, 0.75)
	movement = false

func throw_ball():
	pass
