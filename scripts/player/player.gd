class_name Player
extends CharacterBody3D

const SPEED = 10.0

@export_range(0, 2) var gyro_sensibility: float = 0.4

@onready var team: Team = self.get_parent()
@onready var hit_manager: HitManager = $hitManager
@onready var animation_manager: animationManager = $animationManager
@onready var root = $root
@onready var hit_nodes: Node3D = $"root/hitNodes"

var mult_sync: MultiplayerSynchronizer;
var virtual_joystick: VirtualJoystick

var id: int
var is_multiplayer: bool = false;

var ball_cooldown: float = 0.5
var movement: bool = true

var direction: Vector3

func _enter_tree() -> void:
	set_multiplayer_authority(id)

func _ready() -> void:
	hit_manager.connect("hit_ball", hit_ball)

	if has_node("MultiplayerSynchronizer"):
		mult_sync = $MultiplayerSynchronizer
		is_multiplayer = true
		if _is_this_not_multiplayer_authority():
			$hitManager/Sprite3D.hide()
	else:
		virtual_joystick = %"Virtual Joystick"

func _physics_process(delta: float) -> void:
	if _is_this_not_multiplayer_authority():
		return

	movement = virtual_joystick.is_pressed
	animation_manager.idle()

	_calc_hit_roration()

	#if movement and not animation_manager.is_hitting():
	if movement:
		_calc_movement(delta)
		return
	hit_manager.charging = false;

func _calc_movement(_delta: float) -> void:

	var input_dir := Input.get_vector( "move_right", "move_left", "move_down" , "move_up")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y))

	if direction:
		velocity.x = direction.normalized().x * SPEED
		velocity.z = direction.normalized().z * SPEED

		#root.look_at(global_transform.origin - direction, Vector3.UP)
		animation_manager.moving()
		hit_manager.charging = true;
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

# Le dice al animador que haga la animacion de golpear
func hit_ball(charge_level: int):
	LogDuck.d("Realizando un hit de nivel: [b]%s[/b]" % charge_level)
	animation_manager.hit(charge_level)

# Se llama cuando has golpeado un objeto.
func _on_hit_area_body_entered(body):
	if body is Ball:
		var hit_direction = root.global_transform.basis * Vector3.FORWARD
		if is_multiplayer:
			body.kick.rpc(-1 * hit_direction.normalized()*hit_manager.kick_force)
		else:
			body.kick(-1 * hit_direction.normalized()*hit_manager.kick_force)

func _is_this_not_multiplayer_authority() -> bool :
	return is_multiplayer and mult_sync.get_multiplayer_authority() != multiplayer.get_unique_id()

func _calc_hit_roration():
	var gyro_rotation = Input.get_gravity()
	root.rotation.y = -1 * gyro_rotation.x * gyro_sensibility;
