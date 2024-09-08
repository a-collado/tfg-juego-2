class_name Enemy
extends CharacterBody3D

const SPEED = 10.0

@export_range(0, 60) var time_to_stop_charge: int = 5
@export var enemy_ia_follow: EnemyIAFollow
## Porteria en la que tiene que marcar el enemigo
@export var goal_to_score: Node3D
## Porcentaje de velocidad extra al caminar hacia atras
@export_range(1,2,0.01) var backwards_speed_boost: float = 1.15

@onready var team: Team = self.get_parent()
@onready var hit_manager: HitManager = $hitManager
@onready var animation_manager: animationManager = $animationManager
@onready var root = $root
@onready var nav_agent: NavigationAgent3D = $navigationAgent
@onready var hit_nodes: Node3D = $hitNodes
@onready var hit_area: Area3D = $hitNodes/hitArea
@onready var hit_prediction_area: Area3D = $hitNodes/hitPredictionArea
@onready var sound_manager: SoundManager = $soundManager

var movement := false
var last_movement:int = 0

func _ready():
	hit_manager.connect("hit_ball", hit_ball)

func _physics_process(delta: float) -> void:
	if movement:
		last_movement = 0
		_calc_movement(delta)
		return

	if last_movement > time_to_stop_charge:
		hit_manager.charging = false
		last_movement = 0

	last_movement += 1
	_calc_rotation()

func _calc_movement(_delta: float) -> void:
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var direction = (next_location - current_location).normalized()
	direction.y = 0

	if direction:

		var speed = SPEED
		if direction.z < 0:
			speed *= backwards_speed_boost

		velocity.x = direction.x * speed
		velocity.z = direction.z * speed

		var look_to: Vector3 = global_transform.origin - direction
		if (not root.global_position.is_equal_approx(look_to)):
			root.look_at(look_to, Vector3.UP)

		animation_manager.moving()
		hit_manager.charging = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

		animation_manager.idle()

	move_and_slide()

func hit_ball(charge_level: int):
	animation_manager.hit(charge_level)
	hit_manager.charge_level = charge_level

func _on_hit_area_body_entered(body:Node3D) -> void:
	if body is Ball:
		var hit_direction = hit_nodes.global_transform.basis * Vector3.FORWARD
		body.kick(-1 * hit_direction.normalized() * hit_manager.get_kick_force() )

func _calc_rotation() -> void:
	var goal_position = goal_to_score.transform.origin
	goal_position.z = -1 * goal_position.z
	goal_position.x = -1 * goal_position.x
	hit_nodes.look_at(goal_position)

func _on_attack_reset_prediction_area() -> void:
	hit_prediction_area.monitoring = false
	hit_prediction_area.monitoring = true

func _on_animation_manager_bat_swing_sound(charge_level:int) -> void:
	sound_manager.play_bat_swing_sound(charge_level)

