class_name Player
extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

#@onready var ball: Ball = %Ball
@onready var team: Team = self.get_parent()
@onready var ball_timer: Timer = $Timer
@onready var hit_manager: HitManager = $hitManager
@onready var animation_manager: animationManager = $animationManager
@onready var root = $root

#DEBUG
@onready var debugDrawer: debugDrawer =  $debugDrawer;

var mult_sync: MultiplayerSynchronizer;
var virtual_joystick: VirtualJoystick

var id: int
var is_multiplayer: bool = false;

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var ball_cooldown: float = 0.5
var movement: bool = true

var direction: Vector3

func _enter_tree() -> void:
	set_multiplayer_authority(id)

func _ready() -> void:
	hit_manager.connect("hit_ball", hit_ball)
	ball_timer.wait_time = ball_cooldown
	if has_node("MultiplayerSynchronizer"):
		mult_sync = $MultiplayerSynchronizer
		is_multiplayer = true
	else:
		virtual_joystick = %"Virtual Joystick"

func _physics_process(delta: float) -> void:
	if is_multiplayer && mult_sync.get_multiplayer_authority() != multiplayer.get_unique_id():
		return

	movement = virtual_joystick.is_pressed
	debugDrawer.joystick_pressed = movement
	animation_manager.idle()

	if movement:
		_calc_movement(delta)
		return

	hit_manager.charging = false;

func _calc_movement(_delta: float) -> void:

	var input_dir := Input.get_vector( "move_right", "move_left", "move_down" , "move_up")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

		debugDrawer.joystick_direction = direction
		root.look_at(global_transform.origin - direction, Vector3.UP)
		animation_manager.moving()
		hit_manager.charging = true;
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

# Le dice al animador que haga la animacion de golpear
func hit_ball():
	animation_manager.hit()

# Se llama cuando has golepado un objeto.
func _on_hit_area_body_entered(body):
	if body is RigidBody3D:
		hit_manager.hit_ball_transfer_force.rpc(direction, body)
