class_name Player
extends CharacterBody3D

const SPEED = 10.0

## Sensibilidad del giroscopio para girar el indicador de dirección
@export_range(0, 2) var gyro_sensibility: float = 0.4
## Cuantos frames puede estar quieto el personaje antes de dejar de cargar el golpe
@export_range(0, 60) var time_to_stop_charge: int = 5
## Porcentaje de velocidad extra al caminar hacia atras
@export_range(1,2,0.01) var backwards_speed_boost: float = 1.15

@onready var team: Team = self.get_parent()
@onready var hit_manager: HitManager = $hitManager
@onready var animation_manager: animationManager = $animationManager
@onready var root = $root
@onready var hit_nodes: Node3D = $hitNodes

var mult_sync: MultiplayerSynchronizer;
var virtual_joystick: VirtualJoystick

var id: int
var is_multiplayer: bool = false;

var ball_cooldown: float = 0.5
var movement: bool = true
var _last_movement:int = 0

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
		_last_movement = 0
		_calc_movement(delta)
		return

	if _last_movement > time_to_stop_charge:
		hit_manager.charging = false;
		_last_movement = 0

	_last_movement += 1

func _calc_movement(_delta: float) -> void:

	var input_dir := Input.get_vector( "move_right", "move_left", "move_down" , "move_up")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y))

	if direction:

		var speed = SPEED
		if (team.name == 'Team A' and direction.z > 0) or (team.name == 'Team B' and direction.z < 0):
			speed *= backwards_speed_boost

		velocity.x = direction.normalized().x * speed
		velocity.z = direction.normalized().z * speed

		root.look_at(global_transform.origin - direction, Vector3.UP)
		animation_manager.moving()
		hit_manager.charging = true;
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

# Le dice al animador que haga la animacion de golpear
func hit_ball(charge_level: int):
	animation_manager.hit(charge_level)
	hit_manager.charge_level = charge_level

# Se llama cuando has golpeado un objeto.
func _on_hit_area_body_entered(body):
	if body is Ball:
		var hit_direction = hit_nodes.global_transform.basis * Vector3.FORWARD
		if is_multiplayer:
			body.kick.rpc(-1 * hit_direction.normalized()*hit_manager.get_kick_force())
		else:
			body.kick(-1 * hit_direction.normalized()*hit_manager.get_kick_force())

func _is_this_not_multiplayer_authority() -> bool :
	return is_multiplayer and mult_sync.get_multiplayer_authority() != multiplayer.get_unique_id()

func _calc_hit_roration():
	var gyro_rotation = Input.get_gravity()
	hit_nodes.rotation.y = -1 * gyro_rotation.x * gyro_sensibility;
