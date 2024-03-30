class_name Player
extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

#@onready var ball: Ball = %Ball
@onready var team: Team = self.get_parent()
@onready var ball_timer: Timer = $Timer
@onready var hit_manager: HitManager = $hitManager
@onready var animation_manager: animationManager = $animationManager
@onready var virtual_joystick: VirtualJoystick = %"Virtual Joystick"
@onready var root = $root

#DEBUG
@onready var debugDrawer: debugDrawer =  $debugDrawer;

var mult_sync: MultiplayerSynchronizer;

var id: int
var is_multiplayer: bool = false;

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var ball_cooldown: float = 0.5
var movement: bool = true
var is_joystick_pressed:bool = false;

func _enter_tree() -> void:
	set_multiplayer_authority(id)

func _ready() -> void:
	hit_manager.connect("hit_ball", hit_ball)
	ball_timer.wait_time = ball_cooldown
	if has_node("$MultiplayerSynchronizer"):
		mult_sync = $MultiplayerSynchronizer
		is_multiplayer = true

func _physics_process(delta: float) -> void:
	if is_multiplayer && mult_sync.get_multiplayer_authority() != multiplayer.get_unique_id():
		return

	is_joystick_pressed = virtual_joystick.is_pressed
	debugDrawer.joystick_pressed = is_joystick_pressed
	#ESTO ES TEMPORAL (creo)
	movement = is_joystick_pressed
	animation_manager.idle()

	if movement:
		_calc_movement(delta)
		return

	hit_manager.charging = false;

func _calc_movement(delta: float) -> void:

	var input_dir := Input.get_vector( "move_right", "move_left", "move_down" , "move_up")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		debugDrawer.joystick_direction = direction
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

		root.look_at(global_transform.origin - direction, Vector3.UP)
		animation_manager.moving()
		hit_manager.charging = true;
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func hit_ball():
	animation_manager.hit()
